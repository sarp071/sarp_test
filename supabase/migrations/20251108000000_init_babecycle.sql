-- ============================================================================
-- BabeCycle Database Schema
-- ============================================================================
-- Description: Complete database schema for BabeCycle menstrual cycle tracking
-- Language: All content in English
-- Date: 2025-11-08
-- Version: 1.0.0
-- ============================================================================

-- ============================================================================
-- ENUMS
-- ============================================================================

-- User role: female (tracker) or male (supporter)
CREATE TYPE user_role AS ENUM ('female', 'male');

-- Share scope: what cycle data partner can see
CREATE TYPE share_scope AS ENUM ('phase_only', 'phase_plus_dates');

-- Partner link status
CREATE TYPE link_status AS ENUM ('pending', 'active', 'revoked');

-- Cycle phase types
CREATE TYPE phase_type AS ENUM ('menstrual', 'follicular', 'ovulation', 'luteal', 'pms');

-- ============================================================================
-- TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Profiles: Extended user information
-- ----------------------------------------------------------------------------
CREATE TABLE profiles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL,
  display_name text,
  tz text DEFAULT 'UTC',
  locale text DEFAULT 'en' CHECK (locale IN ('en', 'tr', 'es', 'fr', 'ar')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE profiles IS 'Extended user profile information with role and locale';
COMMENT ON COLUMN profiles.role IS 'User role: female (tracker) or male (supporter)';
COMMENT ON COLUMN profiles.tz IS 'User timezone for smart notification scheduling';
COMMENT ON COLUMN profiles.locale IS 'Preferred language: en (default), tr, es, fr, ar';

-- ----------------------------------------------------------------------------
-- Cycles: Menstrual cycle tracking
-- ----------------------------------------------------------------------------
CREATE TABLE cycles (
  id bigserial PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  start_date date NOT NULL,
  end_date date,
  source text DEFAULT 'manual',
  version int DEFAULT 1,
  is_active boolean GENERATED ALWAYS AS (end_date IS NULL) STORED,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE cycles IS 'Menstrual cycle records with version control for overwrites';
COMMENT ON COLUMN cycles.version IS 'Version number incremented on overwrite for audit trail';
COMMENT ON COLUMN cycles.is_active IS 'Computed field: true if end_date is null (ongoing cycle)';
COMMENT ON COLUMN cycles.source IS 'Data source: manual, imported, predicted';

-- ----------------------------------------------------------------------------
-- Cycle Corrections: Audit trail for historical changes
-- ----------------------------------------------------------------------------
CREATE TABLE cycle_corrections (
  id bigserial PRIMARY KEY,
  cycle_id bigint NOT NULL REFERENCES cycles(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  prev_start date,
  prev_end date,
  new_start date,
  new_end date,
  reason text,
  created_at timestamptz DEFAULT now()
);

COMMENT ON TABLE cycle_corrections IS 'Audit trail for cycle date modifications';
COMMENT ON COLUMN cycle_corrections.reason IS 'User-provided reason for correction';

-- ----------------------------------------------------------------------------
-- Daily Logs: Mood, symptoms, notes
-- ----------------------------------------------------------------------------
CREATE TABLE daily_logs (
  id bigserial PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  date date NOT NULL,
  mood text,
  symptoms jsonb DEFAULT '[]'::jsonb,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE (user_id, date)
);

COMMENT ON TABLE daily_logs IS 'Daily tracking of mood, symptoms, and notes';
COMMENT ON COLUMN daily_logs.symptoms IS 'Array of symptom objects: [{name, severity}]';
COMMENT ON COLUMN daily_logs.mood IS 'Mood state: happy, neutral, sad, crying, angry';

-- ----------------------------------------------------------------------------
-- Partner Links: N:N relationships between users
-- ----------------------------------------------------------------------------
CREATE TABLE partner_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  female_user uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  male_user uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  status link_status DEFAULT 'pending',
  share_scope share_scope DEFAULT 'phase_only',
  invite_code text UNIQUE,
  invite_expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT different_users CHECK (female_user != male_user),
  UNIQUE (female_user, male_user, status)
);

COMMENT ON TABLE partner_links IS 'Partner sharing links with granular privacy controls';
COMMENT ON COLUMN partner_links.share_scope IS 'phase_only: partner sees phase but not dates; phase_plus_dates: full access';
COMMENT ON COLUMN partner_links.invite_code IS 'One-time invite code for partner linking';

-- ----------------------------------------------------------------------------
-- User Notification Preferences: Global settings
-- ----------------------------------------------------------------------------
CREATE TABLE user_notification_prefs (
  user_id uuid PRIMARY KEY REFERENCES profiles(user_id) ON DELETE CASCADE,
  quiet_hours jsonb DEFAULT '{"start":"22:00","end":"08:00"}'::jsonb,
  channel text DEFAULT 'push',
  enabled boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE user_notification_prefs IS 'Global notification preferences per user';
COMMENT ON COLUMN user_notification_prefs.quiet_hours IS 'Time range when notifications are muted';
COMMENT ON COLUMN user_notification_prefs.channel IS 'Notification channel: push, email, sms';

-- ----------------------------------------------------------------------------
-- Link Notification Preferences: Per-partner settings
-- ----------------------------------------------------------------------------
CREATE TABLE link_notification_prefs (
  link_id uuid PRIMARY KEY REFERENCES partner_links(id) ON DELETE CASCADE,
  critical_window boolean DEFAULT true,
  t_minus_3 boolean DEFAULT true,
  on_start boolean DEFAULT true,
  on_mid boolean DEFAULT true,
  on_end boolean DEFAULT true,
  phase_transitions jsonb DEFAULT '{"follicular":true,"ovulation":true,"luteal":true,"pms":true}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE link_notification_prefs IS 'Per-partner notification settings for male users';
COMMENT ON COLUMN link_notification_prefs.critical_window IS 'Notify 3 days before expected period start';
COMMENT ON COLUMN link_notification_prefs.t_minus_3 IS 'Notify on T-3 days warning';

-- ----------------------------------------------------------------------------
-- Notifications Queue: Scheduled notification delivery
-- ----------------------------------------------------------------------------
CREATE TABLE notifications_queue (
  id bigserial PRIMARY KEY,
  link_id uuid REFERENCES partner_links(id) ON DELETE CASCADE,
  male_user uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  female_user uuid NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
  kind text NOT NULL,
  scheduled_at timestamptz NOT NULL,
  payload jsonb DEFAULT '{}'::jsonb,
  status text DEFAULT 'pending',
  sent_at timestamptz,
  created_at timestamptz DEFAULT now()
);

COMMENT ON TABLE notifications_queue IS 'Queue for scheduled notifications with timezone-aware delivery';
COMMENT ON COLUMN notifications_queue.kind IS 'Notification type: t_minus_3, period_started, phase_transition, etc.';
COMMENT ON COLUMN notifications_queue.payload IS 'Additional context data for notification template';

-- ----------------------------------------------------------------------------
-- Translations: Future dynamic content
-- ----------------------------------------------------------------------------
CREATE TABLE translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL,
  locale text NOT NULL,
  value text NOT NULL,
  context text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE (key, locale)
);

COMMENT ON TABLE translations IS 'Dynamic content translations (future admin-managed content)';
COMMENT ON COLUMN translations.context IS 'Additional context for translators';

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX idx_cycles_user_start ON cycles(user_id, start_date DESC);
CREATE INDEX idx_cycles_active ON cycles(user_id) WHERE is_active = true;
CREATE INDEX idx_daily_logs_user_date ON daily_logs(user_id, date DESC);
CREATE INDEX idx_partner_links_female ON partner_links(female_user, status);
CREATE INDEX idx_partner_links_male ON partner_links(male_user, status);
CREATE INDEX idx_notifications_queue_scheduled ON notifications_queue(male_user, scheduled_at) WHERE status = 'pending';
CREATE INDEX idx_translations_key_locale ON translations(key, locale);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycles ENABLE ROW LEVEL SECURITY;
ALTER TABLE cycle_corrections ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE partner_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_notification_prefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_notification_prefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE translations ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- Profiles RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Cycles RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view own cycles"
  ON cycles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own cycles"
  ON cycles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own cycles"
  ON cycles FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own cycles"
  ON cycles FOR DELETE
  USING (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Cycle Corrections RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view own corrections"
  ON cycle_corrections FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own corrections"
  ON cycle_corrections FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Daily Logs RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view own logs"
  ON daily_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own logs"
  ON daily_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own logs"
  ON daily_logs FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own logs"
  ON daily_logs FOR DELETE
  USING (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Partner Links RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view their partner links"
  ON partner_links FOR SELECT
  USING (auth.uid() = female_user OR auth.uid() = male_user);

CREATE POLICY "Female users can create links"
  ON partner_links FOR INSERT
  WITH CHECK (auth.uid() = female_user);

CREATE POLICY "Users can update their links"
  ON partner_links FOR UPDATE
  USING (auth.uid() = female_user OR auth.uid() = male_user);

-- ----------------------------------------------------------------------------
-- User Notification Prefs RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view own notification prefs"
  ON user_notification_prefs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own notification prefs"
  ON user_notification_prefs FOR ALL
  USING (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- Link Notification Prefs RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Link members can view notification prefs"
  ON link_notification_prefs FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM partner_links
      WHERE partner_links.id = link_notification_prefs.link_id
      AND (partner_links.female_user = auth.uid() OR partner_links.male_user = auth.uid())
    )
  );

CREATE POLICY "Link members can manage notification prefs"
  ON link_notification_prefs FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM partner_links
      WHERE partner_links.id = link_notification_prefs.link_id
      AND (partner_links.female_user = auth.uid() OR partner_links.male_user = auth.uid())
    )
  );

-- ----------------------------------------------------------------------------
-- Notifications Queue RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Users can view their notifications"
  ON notifications_queue FOR SELECT
  USING (auth.uid() = male_user OR auth.uid() = female_user);

-- ----------------------------------------------------------------------------
-- Translations RLS
-- ----------------------------------------------------------------------------
CREATE POLICY "Anyone can read translations"
  ON translations FOR SELECT
  USING (true);

-- ============================================================================
-- VIEWS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Partner Cycle View: Share-scope aware view for male users
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW partner_cycle_view AS
SELECT
  pl.id AS link_id,
  pl.male_user,
  pl.female_user,
  pl.share_scope,
  c.id AS cycle_id,
  c.start_date,
  c.end_date,
  c.is_active,
  CASE
    WHEN pl.share_scope = 'phase_only' THEN NULL
    ELSE c.start_date
  END AS visible_start_date,
  CASE
    WHEN pl.share_scope = 'phase_only' THEN NULL
    ELSE c.end_date
  END AS visible_end_date
FROM partner_links pl
JOIN cycles c ON c.user_id = pl.female_user
WHERE pl.status = 'active';

COMMENT ON VIEW partner_cycle_view IS 'Privacy-aware cycle view respecting share_scope settings';

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Function: Update updated_at timestamp
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- Triggers for updated_at
-- ----------------------------------------------------------------------------
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cycles_updated_at BEFORE UPDATE ON cycles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_daily_logs_updated_at BEFORE UPDATE ON daily_logs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_partner_links_updated_at BEFORE UPDATE ON partner_links
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_notification_prefs_updated_at BEFORE UPDATE ON user_notification_prefs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_link_notification_prefs_updated_at BEFORE UPDATE ON link_notification_prefs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_translations_updated_at BEFORE UPDATE ON translations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
