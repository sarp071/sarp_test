-- ============================================================================
-- BabeCycle Seed Data (Without Auth Users)
-- ============================================================================
-- Description: Test data without requiring auth.users
-- This creates mock data directly in tables for testing
-- Language: All content in English
-- Date: 2025-11-08
-- ============================================================================

-- Note: This seed assumes you'll create real users via Supabase Auth signup
-- For now, we'll skip user-dependent data and just show table structure

-- ============================================================================
-- Translations (No FK dependency)
-- ============================================================================

INSERT INTO translations (key, locale, value, context) VALUES
  ('welcome_message', 'en', 'Welcome to BabeCycle', 'Homepage greeting'),
  ('period_started', 'en', 'Your period started today', 'Notification message'),
  ('phase_follicular', 'en', 'Follicular Phase', 'Cycle phase name'),
  ('phase_menstrual', 'en', 'Menstrual Phase', 'Cycle phase name'),
  ('phase_ovulation', 'en', 'Ovulation Phase', 'Cycle phase name'),
  ('phase_luteal', 'en', 'Luteal Phase', 'Cycle phase name'),
  ('phase_pms', 'en', 'PMS Phase', 'Cycle phase name'),
  ('symptom_cramps', 'en', 'Cramps', 'Symptom name'),
  ('symptom_headache', 'en', 'Headache', 'Symptom name'),
  ('symptom_bloating', 'en', 'Bloating', 'Symptom name'),
  ('symptom_fatigue', 'en', 'Fatigue', 'Symptom name');

-- ============================================================================
-- Instructions for Testing
-- ============================================================================

-- To test with real users:
-- 1. Go to Supabase Dashboard > Authentication > Users
-- 2. Click "Add user" (via email)
-- 3. Create 2 female users and 2 male users
-- 4. Get their UUIDs from the users table
-- 5. Insert into profiles table:
--
-- INSERT INTO profiles (user_id, role, display_name, tz, locale) VALUES
--   ('your-uuid-1', 'female', 'Alice Johnson', 'America/New_York', 'en'),
--   ('your-uuid-2', 'male', 'Charlie Brown', 'America/New_York', 'en');
--
-- 6. Then add cycles, logs, and partner links using those UUIDs

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
