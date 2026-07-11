BEGIN;

-- 1. Add 'attendance' module permissions
INSERT INTO permissions (module, action) VALUES 
    ('attendance', 'create'),
    ('attendance', 'read'),
    ('attendance', 'update'),
    ('attendance', 'delete')
ON CONFLICT (key) DO NOTHING;

-- 2. Grant 'attendance' permissions to the 'master' role (receives everything usually)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'master'
ON CONFLICT DO NOTHING;

-- Grant to 'accountant' or other specific roles as needed
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r JOIN permissions p 
    ON p.module = 'attendance'
WHERE r.name = 'accountant'
ON CONFLICT DO NOTHING;

-- 3. RLS for attendance_daily
ALTER TABLE attendance_daily ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "attendance_daily_select" ON attendance_daily;
CREATE POLICY "attendance_daily_select" ON attendance_daily FOR SELECT TO authenticated USING (current_user_has_permission('attendance.read'));
DROP POLICY IF EXISTS "attendance_daily_insert" ON attendance_daily;
CREATE POLICY "attendance_daily_insert" ON attendance_daily FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('attendance.create'));
DROP POLICY IF EXISTS "attendance_daily_update" ON attendance_daily;
CREATE POLICY "attendance_daily_update" ON attendance_daily FOR UPDATE TO authenticated USING (current_user_has_permission('attendance.update')) WITH CHECK (current_user_has_permission('attendance.update'));
DROP POLICY IF EXISTS "attendance_daily_delete" ON attendance_daily;
CREATE POLICY "attendance_daily_delete" ON attendance_daily FOR DELETE TO authenticated USING (current_user_has_permission('attendance.delete'));

-- 4. RLS for attendance_adjustments
ALTER TABLE attendance_adjustments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "attendance_adjustments_select" ON attendance_adjustments;
CREATE POLICY "attendance_adjustments_select" ON attendance_adjustments FOR SELECT TO authenticated USING (current_user_has_permission('attendance.read'));
DROP POLICY IF EXISTS "attendance_adjustments_insert" ON attendance_adjustments;
CREATE POLICY "attendance_adjustments_insert" ON attendance_adjustments FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('attendance.create'));
DROP POLICY IF EXISTS "attendance_adjustments_update" ON attendance_adjustments;
CREATE POLICY "attendance_adjustments_update" ON attendance_adjustments FOR UPDATE TO authenticated USING (current_user_has_permission('attendance.update')) WITH CHECK (current_user_has_permission('attendance.update'));
DROP POLICY IF EXISTS "attendance_adjustments_delete" ON attendance_adjustments;
CREATE POLICY "attendance_adjustments_delete" ON attendance_adjustments FOR DELETE TO authenticated USING (current_user_has_permission('attendance.delete'));

-- 5. RLS for daily_work_assignments
ALTER TABLE daily_work_assignments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "daily_work_assignments_select" ON daily_work_assignments;
CREATE POLICY "daily_work_assignments_select" ON daily_work_assignments FOR SELECT TO authenticated USING (current_user_has_permission('attendance.read'));
DROP POLICY IF EXISTS "daily_work_assignments_insert" ON daily_work_assignments;
CREATE POLICY "daily_work_assignments_insert" ON daily_work_assignments FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('attendance.create'));
DROP POLICY IF EXISTS "daily_work_assignments_update" ON daily_work_assignments;
CREATE POLICY "daily_work_assignments_update" ON daily_work_assignments FOR UPDATE TO authenticated USING (current_user_has_permission('attendance.update')) WITH CHECK (current_user_has_permission('attendance.update'));
DROP POLICY IF EXISTS "daily_work_assignments_delete" ON daily_work_assignments;
CREATE POLICY "daily_work_assignments_delete" ON daily_work_assignments FOR DELETE TO authenticated USING (current_user_has_permission('attendance.delete'));

-- 6. RLS for daily_work_segments
ALTER TABLE daily_work_segments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "daily_work_segments_select" ON daily_work_segments;
CREATE POLICY "daily_work_segments_select" ON daily_work_segments FOR SELECT TO authenticated USING (current_user_has_permission('attendance.read'));
DROP POLICY IF EXISTS "daily_work_segments_insert" ON daily_work_segments;
CREATE POLICY "daily_work_segments_insert" ON daily_work_segments FOR INSERT TO authenticated WITH CHECK (current_user_has_permission('attendance.create'));
DROP POLICY IF EXISTS "daily_work_segments_update" ON daily_work_segments;
CREATE POLICY "daily_work_segments_update" ON daily_work_segments FOR UPDATE TO authenticated USING (current_user_has_permission('attendance.update')) WITH CHECK (current_user_has_permission('attendance.update'));
DROP POLICY IF EXISTS "daily_work_segments_delete" ON daily_work_segments;
CREATE POLICY "daily_work_segments_delete" ON daily_work_segments FOR DELETE TO authenticated USING (current_user_has_permission('attendance.delete'));

COMMIT;
