-- ============================================================================
-- BabeCycle Minimal Seed Data
-- ============================================================================
-- Description: Minimal test data with 2 real users
-- Language: All content in English
-- Date: 2025-11-08
-- ============================================================================

-- ============================================================================
-- Profiles (2 users: 1 female, 1 male)
-- ============================================================================

INSERT INTO profiles (user_id, role, display_name, tz, locale) VALUES
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', 'female', 'Alice Johnson', 'America/New_York', 'en'),
  ('2cb69b83-80fb-4cce-a768-7c3338d5fb7e', 'male', 'Charlie Brown', 'America/New_York', 'en');

-- ============================================================================
-- Cycles (Alice's cycles - last 3 months)
-- ============================================================================

INSERT INTO cycles (user_id, start_date, end_date, source, version) VALUES
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-08-15', '2025-08-20', 'manual', 1),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-09-12', '2025-09-17', 'manual', 1),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-10-10', '2025-10-15', 'manual', 1),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-11-07', NULL, 'manual', 1);  -- Active cycle

-- ============================================================================
-- Daily Logs (Alice's logs)
-- ============================================================================

INSERT INTO daily_logs (user_id, date, mood, symptoms, notes) VALUES
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-11-07', 'sad', '[{"name":"Cramps","severity":"moderate"},{"name":"Fatigue","severity":"mild"}]'::jsonb, 'First day, feeling tired'),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-11-06', 'angry', '[{"name":"Bloating","severity":"moderate"},{"name":"Headache","severity":"severe"}]'::jsonb, 'PMS symptoms strong today'),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-11-05', 'neutral', '[{"name":"Bloating","severity":"mild"}]'::jsonb, 'Feeling okay'),
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-10-20', 'happy', '[]'::jsonb, 'Great energy today!');

-- ============================================================================
-- Partner Link (Alice <-> Charlie)
-- ============================================================================

INSERT INTO partner_links (id, female_user, male_user, status, share_scope, invite_code, invite_expires_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2cb69b83-80fb-4cce-a768-7c3338d5fb7e', 'active', 'phase_plus_dates', NULL, NULL);

-- ============================================================================
-- User Notification Preferences
-- ============================================================================

INSERT INTO user_notification_prefs (user_id, quiet_hours, channel, enabled) VALUES
  ('cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '{"start":"22:00","end":"08:00"}'::jsonb, 'push', true),
  ('2cb69b83-80fb-4cce-a768-7c3338d5fb7e', '{"start":"22:00","end":"08:00"}'::jsonb, 'push', true);

-- ============================================================================
-- Link Notification Preferences (Charlie's preferences for Alice)
-- ============================================================================

INSERT INTO link_notification_prefs (link_id, critical_window, t_minus_3, on_start, on_mid, on_end, phase_transitions) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', true, true, true, true, true, '{"follicular":true,"ovulation":true,"luteal":true,"pms":true}'::jsonb);

-- ============================================================================
-- Sample Notifications Queue
-- ============================================================================

-- Upcoming notification for Charlie about Alice's cycle
INSERT INTO notifications_queue (link_id, male_user, female_user, kind, scheduled_at, payload, status) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '2cb69b83-80fb-4cce-a768-7c3338d5fb7e', 'cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', 'period_mid', now() + interval '1 day', '{"day":3,"message":"Midway through period"}'::jsonb, 'pending');

-- Sent notification (historical)
INSERT INTO notifications_queue (link_id, male_user, female_user, kind, scheduled_at, payload, status, sent_at) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '2cb69b83-80fb-4cce-a768-7c3338d5fb7e', 'cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', 'period_started', now() - interval '1 day', '{"message":"Period started today"}'::jsonb, 'sent', now() - interval '1 day');

-- ============================================================================
-- Translations (English only)
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
-- Sample Cycle Correction (Alice corrected a past cycle)
-- ============================================================================

INSERT INTO cycle_corrections (cycle_id, user_id, prev_start, prev_end, new_start, new_end, reason) VALUES
  (1, 'cc4b88df-74c6-4e0e-9725-8b0e5ae4df88', '2025-08-14', '2025-08-19', '2025-08-15', '2025-08-20', 'Realized I marked the wrong dates initially');

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================
