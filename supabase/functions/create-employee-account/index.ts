// import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
// import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// const corsHeaders = {
//   'Access-Control-Allow-Origin': '*',
//   'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
// }

// serve(async (req: Request) => {
//   // Handle CORS preflight requests
//   if (req.method === 'OPTIONS') {
//     return new Response('ok', { headers: corsHeaders })
//   }

//   // Only allow POST
//   if (req.method !== "POST") {
//     return new Response(JSON.stringify({ error: "Method not allowed" }), {
//       status: 405,
//       headers: { ...corsHeaders, "Content-Type": "application/json" },
//     });
//   }

//   try {
//     const {
//       email,
//       password,
//       name,
//       phone,
//       cnic,
//       joining_date,
//       is_active,
//       role_id,
//     } = await req.json();

//     // Validate required fields
//     if (!email || !password || !name || !phone || !joining_date) {
//       return new Response(
//         JSON.stringify({
//           error:
//             "Missing required fields: email, password, name, phone, joining_date",
//         }),
//         { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
//       );
//     }

//     // Build a Supabase admin client using the Service Role key.
//     // SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are built-in secrets in all
//     // Supabase Edge Functions — no manual configuration needed.
//     const supabaseAdmin = createClient(
//       Deno.env.get("SUPABASE_URL")!,
//       Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
//       { auth: { autoRefreshToken: false, persistSession: false } }
//     );

//     // 1. Create the auth user — does NOT touch the calling user's session
//     const { data: authData, error: authError } =
//       await supabaseAdmin.auth.admin.createUser({
//         email,
//         password,
//         email_confirm: true, // confirm immediately so the employee can log in right away
//       });

//     if (authError) {
//       return new Response(JSON.stringify({ error: authError.message }), {
//         status: 400,
//         headers: { ...corsHeaders, "Content-Type": "application/json" },
//       });
//     }

//     const userId = authData.user.id;

//     // 2. Insert the employee row linked to the new auth user.
//     //    NOTE: if this fails with "column email does not exist", run this SQL
//     //    in your Supabase SQL Editor first:
//     //      ALTER TABLE employees ADD COLUMN IF NOT EXISTS email TEXT;
//     const insertPayload: Record<string, unknown> = {
//       name,
//       phone,
//       cnic: cnic ?? null,
//       joining_date,
//       is_active: is_active ?? true,
//       role_id: role_id ?? null,
//       user_id: userId,
//     };

//     // Only include email if the column exists (safe to always include after migration)
//     if (email) insertPayload["email"] = email;

//     const { data: empData, error: empError } = await supabaseAdmin
//       .from("employees")
//       .insert(insertPayload)
//       .select("id")
//       .single();

//     if (empError) {
//       // Auth user was created but employee insert failed — clean up the orphaned auth user
//       await supabaseAdmin.auth.admin.deleteUser(userId);
//       return new Response(
//         JSON.stringify({
//           error: `Employee insert failed: ${empError.message}`,
//         }),
//         { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
//       );
//     }

//     return new Response(JSON.stringify({ userId, employeeId: empData.id }), {
//       status: 200,
//       headers: { ...corsHeaders, "Content-Type": "application/json" },
//     });
//   } catch (e) {
//     return new Response(JSON.stringify({ error: String(e) }), {
//       status: 500,
//       headers: { ...corsHeaders, "Content-Type": "application/json" },
//     });
//   }
// });
