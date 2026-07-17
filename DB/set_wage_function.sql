CREATE OR REPLACE FUNCTION public.set_operator_wage(
  p_operator_id BIGINT,
  p_wage_role_id BIGINT,
  p_daily_wage NUMERIC,
  p_overtime_rate NUMERIC,
  p_effective_from DATE
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO public.operator_wage_rates (
    operator_id, 
    wage_role_id, 
    daily_wage, 
    overtime_rate_per_hour, 
    effective_from
  )
  VALUES (
    p_operator_id, 
    p_wage_role_id, 
    p_daily_wage, 
    p_overtime_rate, 
    p_effective_from
  )
  ON CONFLICT (operator_id, wage_role_id, effective_from) 
  DO UPDATE SET
    daily_wage = EXCLUDED.daily_wage,
    overtime_rate_per_hour = EXCLUDED.overtime_rate_per_hour,
    updated_at = NOW();
END;
$$;
