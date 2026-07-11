// Supabase Edge Function: ingest-attendance
//
// Receives raw biometric punches from the desktop sync agent, verifies the
// agent's bearer token, maps device employee codes to operators, and
// inserts accepted events into attendance_events. This function only
// handles raw punches — it never calculates payroll, wages, or overtime.

import { createClient } from "npm:@supabase/supabase-js@2";

type IncomingRecord = {
  local_id: number;
  device_id: string;
  employee_code: string;
  punched_at: string;
  status?: number | null;
  punch?: number | null;
};

type Ack = {
  local_id: number;
  status: "accepted" | "duplicate" | "rejected";
  backend_event_id?: string;
  error?: string;
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });

async function sha256Hex(value: string): Promise<string> {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest("SHA-256", bytes);

  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const auth = req.headers.get("authorization") ?? "";
  const token = auth.startsWith("Bearer ")
    ? auth.slice("Bearer ".length).trim()
    : "";

  if (!token) {
    return json({ error: "Missing bearer token" }, 401);
  }

  const body = await req.json().catch(() => null);

  if (!body || !Array.isArray(body.records)) {
    return json({ error: "Invalid request body" }, 400);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !serviceRoleKey) {
    return json({ error: "Missing Supabase environment variables" }, 500);
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey);
  const tokenHash = await sha256Hex(token);

  const { data: agentToken, error: tokenError } = await supabase
    .from("attendance_agent_tokens")
    .select("id, attendance_device_id, is_active")
    .eq("token_hash", tokenHash)
    .maybeSingle();

  if (tokenError || !agentToken?.is_active) {
    return json({ error: "Invalid desktop agent token" }, 401);
  }

  await supabase
    .from("attendance_agent_tokens")
    .update({ last_used_at: new Date().toISOString() })
    .eq("id", agentToken.id);

  const runUuid = body.run_uuid;
  const records = body.records as IncomingRecord[];
  const acknowledgements: Ack[] = [];

  for (const record of records) {
    if (!record.local_id || !record.employee_code || !record.punched_at) {
      acknowledgements.push({
        local_id: record.local_id,
        status: "rejected",
        error: "Missing local_id, employee_code, or punched_at",
      });
      continue;
    }

    const { data: mapping, error: mappingError } = await supabase
      .from("operator_device_mappings")
      .select("operator_id")
      .eq("attendance_device_id", agentToken.attendance_device_id)
      .eq("device_employee_code", record.employee_code)
      .eq("is_active", true)
      .maybeSingle();

    if (mappingError || !mapping) {
      acknowledgements.push({
        local_id: record.local_id,
        status: "rejected",
        error: `No active operator mapping for device employee code ${record.employee_code}`,
      });
      continue;
    }

    const event = {
      attendance_device_id: agentToken.attendance_device_id,
      operator_id: mapping.operator_id,
      device_employee_code: record.employee_code,
      punched_at: record.punched_at,
      status: record.status ?? null,
      punch: record.punch ?? null,
      first_seen_run_uuid: runUuid,
    };

    const { data: inserted, error: insertError } = await supabase
      .from("attendance_events")
      .insert(event)
      .select("id")
      .single();

    if (!insertError && inserted) {
      acknowledgements.push({
        local_id: record.local_id,
        status: "accepted",
        backend_event_id: String(inserted.id),
      });
      continue;
    }

    if (insertError?.code === "23505") {
      const { data: existing } = await supabase
        .from("attendance_events")
        .select("id")
        .eq("attendance_device_id", agentToken.attendance_device_id)
        .eq("device_employee_code", record.employee_code)
        .eq("punched_at", record.punched_at)
        .maybeSingle();

      acknowledgements.push({
        local_id: record.local_id,
        status: "duplicate",
        backend_event_id: existing?.id ? String(existing.id) : undefined,
      });
      continue;
    }

    acknowledgements.push({
      local_id: record.local_id,
      status: "rejected",
      error: insertError?.message ?? "Unknown insert error",
    });
  }

  const acceptedCount = acknowledgements.filter((x) => x.status === "accepted").length;
  const duplicateCount = acknowledgements.filter((x) => x.status === "duplicate").length;
  const rejectedCount = acknowledgements.filter((x) => x.status === "rejected").length;

  const { data: existingRun } = await supabase
    .from("attendance_sync_runs")
    .select("records_received, records_accepted, records_duplicate, records_rejected")
    .eq("run_uuid", runUuid)
    .maybeSingle();

  await supabase.from("attendance_sync_runs").upsert(
    {
      run_uuid: runUuid,
      attendance_device_id: agentToken.attendance_device_id,
      records_received: (existingRun?.records_received ?? 0) + records.length,
      records_accepted: (existingRun?.records_accepted ?? 0) + acceptedCount,
      records_duplicate: (existingRun?.records_duplicate ?? 0) + duplicateCount,
      records_rejected: (existingRun?.records_rejected ?? 0) + rejectedCount,
    },
    { onConflict: "run_uuid" },
  );

  return json({ records: acknowledgements });
});