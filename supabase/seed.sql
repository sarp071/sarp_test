-- ============================================================================
-- BabeCycle Seed Data
-- ============================================================================
-- Description: Test data for BabeCycle application
-- Language: All content in English
-- Date: 2025-11-08
-- ============================================================================

-- Note: This assumes auth.users already has these UUIDs created via Supabase Auth
-- In real usage, these would be created through signup flow

-- ============================================================================
-- Test Users (Profiles)
-- ============================================================================

-- Female Users
INSERT INTO profiles (user_id, role, display_name, tz, locale) VALUES
  ('11111111-1111-1111-1111-111111111111', 'female', 'Alice Johnson', 'America/New_York', 'en'),
  ('22222222-2222-2222-2222-222222222222', 'female', 'Bella Martinez', 'America/Los_Angeles', 'en');

-- Male Users
INSERT INTO profiles (user_id, role, display_name, tz, locale) VALUES
  ('33333333-3333-3333-3333-333333333333', 'male', 'Charlie Brown', 'America/New_York', 'en'),
  ('44444444-4444-4444-4444-444444444444', 'male', 'David Kim', 'America/Chicago', 'en');

-- ============================================================================
-- Cycles (Last 3 months for female users)
-- ============================================================================

-- Alice's Cycles (regular 28-day cycle)
INSERT INTO cycles (user_id, start_date, end_date, source, version) VALUES
  ('11111111-1111-1111-1111-111111111111', '2025-08-15', '2025-08-20', 'manual', 1),
  ('11111111-1111-1111-1111-111111111111', '2025-09-12', '2025-09-17', 'manual', 1),
  ('11111111-1111-1111-1111-111111111111', '2025-10-10', '2025-10-15', 'manual', 1),
  ('11111111-1111-1111-1111-111111111111', '2025-11-07', NULL, 'manual', 1);  -- Active cycle

-- Bella's Cycles (slightly irregular 30-32 day cycle)
INSERT INTO cycles (user_id, start_date, end_date, source, version) VALUES
  ('22222222-2222-2222-2222-222222222222', '2025-08-10', '2025-08-16', 'manual', 1),
  ('22222222-2222-2222-2222-222222222222', '2025-09-11', '2025-09-17', 'manual', 1),
  ('22222222-2222-2222-2222-222222222222', '2025-10-13', '2025-10-18', 'manual', 1);

-- ============================================================================
-- Daily Logs (Sample entries with English content)
-- ============================================================================

-- Alice's Daily Logs
INSERT INTO daily_logs (user_id, date, mood, symptoms, notes) VALUES
  ('11111111-1111-1111-1111-111111111111', '2025-11-07', 'sad', '[{"name":"Cramps","severity":"moderate"},{"name":"Fatigue","severity":"mild"}]'::jsonb, 'First day, feeling tired'),
  ('11111111-1111-1111-1111-111111111111', '2025-11-06', 'angry', '[{"name":"Bloating","severity":"moderate"},{"name":"Headache","severity":"severe"}]'::jsonb, 'PMS symptoms strong today'),
  ('11111111-1111-1111-1111-111111111111', '2025-11-05', 'neutral', '[{"name":"Bloating","severity":"mild"}]'::jsonb, 'Feeling okay'),
  ('11111111-1111-1111-1111-111111111111', '2025-10-20', 'happy', '[]'::jsonb, 'Great energy today!');

-- Bella's Daily Logs
INSERT INTO daily_logs (user_id, date, mood, symptoms, notes) VALUES
  ('22222222-2222-2222-2222-222222222222', '2025-10-13', 'crying', '[{"name":"Cramps","severity":"severe"},{"name":"Fatigue","severity":"severe"}]'::jsonb, 'Rough start, staying home'),
  ('22222222-2222-2222-2222-222222222222', '2025-10-14', 'sad', '[{"name":"Cramps","severity":"moderate"}]'::jsonb, 'Better than yesterday'),
  ('22222222-2222-2222-2222-222222222222', '2025-10-25', 'happy', '[]'::jsonb, 'Feeling energized');

-- ============================================================================
-- Partner Links
-- ============================================================================

-- Active Links
INSERT INTO partner_links (id, female_user, male_user, status, share_scope, invite_code, invite_expires_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'active', 'phase_only', NULL, NULL),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', '44444444-4444-4444-4444-444444444444', 'active', 'phase_plus_dates', NULL, NULL);

-- Pending Link (Alice invited David, awaiting acceptance)
INSERT INTO partner_links (id, female_user, male_user, status, share_scope, invite_code, invite_expires_at) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444', 'pending', 'phase_only', 'INVITE123', now() + interval '7 days');

-- ============================================================================
-- User Notification Preferences
-- ============================================================================

INSERT INTO user_notification_prefs (user_id, quiet_hours, channel, enabled) VALUES
  ('11111111-1111-1111-1111-111111111111', '{"start":"22:00","end":"08:00"}'::jsonb, 'push', true),
  ('22222222-2222-2222-2222-222222222222', '{"start":"23:00","end":"07:00"}'::jsonb, 'push', true),
  ('33333333-3333-3333-3333-333333333333', '{"start":"22:00","end":"08:00"}'::jsonb, 'push', true),
  ('44444444-4444-4444-4444-444444444444', '{"start":"00:00","end":"06:00"}'::jsonb, 'push', true);

-- ============================================================================
-- Link Notification Preferences
-- ============================================================================

-- Charlie's preferences for Alice's link (all enabled)
INSERT INTO link_notification_prefs (link_id, critical_window, t_minus_3, on_start, on_mid, on_end, phase_transitions) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', true, true, true, true, true, '{"follicular":true,"ovulation":true,"luteal":true,"pms":true}'::jsonb);

-- David's preferences for Bella's link (some disabled)
INSERT INTO link_notification_prefs (link_id, critical_window, t_minus_3, on_start, on_mid, on_end, phase_transitions) VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', true, true, true, false, true, '{"follicular":false,"ovulation":true,"luteal":false,"pms":true}'::jsonb);

-- ============================================================================
-- Sample Notifications Queue
-- ============================================================================

-- Upcoming notification for Charlie about Alice's cycle
INSERT INTO notifications_queue (link_id, male_user, female_user, kind, scheduled_at, payload, status) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'period_mid', now() + interval '1 day', '{"day":3,"message":"Midway through period"}'::jsonb, 'pending');

-- Sent notification (historical)
INSERT INTO notifications_queue (link_id, male_user, female_user, kind, scheduled_at, payload, status, sent_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'period_started', now() - interval '1 day', '{"message":"Period started today"}'::jsonb, 'sent', now() - interval '1 day');

-- ============================================================================
-- Sample Translations (English only for now)
-- ============================================================================

INSERT INTO translations (key, locale, value, context) VALUES
  ('welcome_message', 'en', 'Welcome to BabeCycle', 'Homepage greeting'),
  ('period_started', 'en', 'Your period started today', 'Notification message'),
  ('phase_follicular', 'en', 'Follicular Phase', 'Cycle phase name'),
  ('symptom_cramps', 'en', 'Cramps', 'Symptom name');

-- ============================================================================
-- Sample Cycle Correction (Alice corrected a past cycle)
-- ============================================================================

INSERT INTO cycle_corrections (cycle_id, user_id, prev_start, prev_end, new_start, new_end, reason) VALUES
  (1, '11111111-1111-1111-1111-111111111111', '2025-08-14', '2025-08-19', '2025-08-15', '2025-08-20', 'Realized I marked the wrong dates initially');

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
