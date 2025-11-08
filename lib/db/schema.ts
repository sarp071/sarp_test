/**
 * Database Schema Types
 * Generated from BabeCycle Supabase schema
 * All types in English
 */

import { z } from 'zod';

// ============================================================================
// ENUMS
// ============================================================================

export const UserRole = z.enum(['female', 'male']);
export type UserRole = z.infer<typeof UserRole>;

export const ShareScope = z.enum(['phase_only', 'phase_plus_dates']);
export type ShareScope = z.infer<typeof ShareScope>;

export const LinkStatus = z.enum(['pending', 'active', 'revoked']);
export type LinkStatus = z.infer<typeof LinkStatus>;

export const PhaseType = z.enum(['menstrual', 'follicular', 'ovulation', 'luteal', 'pms']);
export type PhaseType = z.infer<typeof PhaseType>;

export const Locale = z.enum(['en', 'tr', 'es', 'fr', 'ar']);
export type Locale = z.infer<typeof Locale>;

// ============================================================================
// TABLE TYPES
// ============================================================================

// ----------------------------------------------------------------------------
// Profile
// ----------------------------------------------------------------------------
export const ProfileSchema = z.object({
  user_id: z.string().uuid(),
  role: UserRole,
  display_name: z.string().nullable(),
  tz: z.string().default('UTC'),
  locale: Locale.default('en'),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type Profile = z.infer<typeof ProfileSchema>;

export const ProfileInsertSchema = ProfileSchema.omit({
  created_at: true,
  updated_at: true,
}).partial({
  tz: true,
  locale: true,
  display_name: true,
});

export type ProfileInsert = z.infer<typeof ProfileInsertSchema>;

// ----------------------------------------------------------------------------
// Cycle
// ----------------------------------------------------------------------------
export const CycleSchema = z.object({
  id: z.number(),
  user_id: z.string().uuid(),
  start_date: z.string().date(),
  end_date: z.string().date().nullable(),
  source: z.string().default('manual'),
  version: z.number().default(1),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type Cycle = z.infer<typeof CycleSchema>;

export const CycleInsertSchema = CycleSchema.omit({
  id: true,
  is_active: true,
  created_at: true,
  updated_at: true,
}).partial({
  end_date: true,
  source: true,
  version: true,
});

export type CycleInsert = z.infer<typeof CycleInsertSchema>;

// ----------------------------------------------------------------------------
// Cycle Correction
// ----------------------------------------------------------------------------
export const CycleCorrectionSchema = z.object({
  id: z.number(),
  cycle_id: z.number(),
  user_id: z.string().uuid(),
  prev_start: z.string().date().nullable(),
  prev_end: z.string().date().nullable(),
  new_start: z.string().date().nullable(),
  new_end: z.string().date().nullable(),
  reason: z.string().nullable(),
  created_at: z.string().datetime(),
});

export type CycleCorrection = z.infer<typeof CycleCorrectionSchema>;

export const CycleCorrectionInsertSchema = CycleCorrectionSchema.omit({
  id: true,
  created_at: true,
});

export type CycleCorrectionInsert = z.infer<typeof CycleCorrectionInsertSchema>;

// ----------------------------------------------------------------------------
// Daily Log
// ----------------------------------------------------------------------------
export const SymptomSchema = z.object({
  name: z.string(),
  severity: z.enum(['mild', 'moderate', 'severe']),
});

export type Symptom = z.infer<typeof SymptomSchema>;

export const DailyLogSchema = z.object({
  id: z.number(),
  user_id: z.string().uuid(),
  date: z.string().date(),
  mood: z.string().nullable(),
  symptoms: z.array(SymptomSchema).default([]),
  notes: z.string().nullable(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type DailyLog = z.infer<typeof DailyLogSchema>;

export const DailyLogInsertSchema = DailyLogSchema.omit({
  id: true,
  created_at: true,
  updated_at: true,
}).partial({
  mood: true,
  symptoms: true,
  notes: true,
});

export type DailyLogInsert = z.infer<typeof DailyLogInsertSchema>;

// ----------------------------------------------------------------------------
// Partner Link
// ----------------------------------------------------------------------------
export const PartnerLinkSchema = z.object({
  id: z.string().uuid(),
  female_user: z.string().uuid(),
  male_user: z.string().uuid(),
  status: LinkStatus.default('pending'),
  share_scope: ShareScope.default('phase_only'),
  invite_code: z.string().nullable(),
  invite_expires_at: z.string().datetime().nullable(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type PartnerLink = z.infer<typeof PartnerLinkSchema>;

export const PartnerLinkInsertSchema = PartnerLinkSchema.omit({
  id: true,
  created_at: true,
  updated_at: true,
}).partial({
  status: true,
  share_scope: true,
  invite_code: true,
  invite_expires_at: true,
});

export type PartnerLinkInsert = z.infer<typeof PartnerLinkInsertSchema>;

// ----------------------------------------------------------------------------
// User Notification Preferences
// ----------------------------------------------------------------------------
export const QuietHoursSchema = z.object({
  start: z.string().regex(/^\d{2}:\d{2}$/), // HH:MM format
  end: z.string().regex(/^\d{2}:\d{2}$/),
});

export type QuietHours = z.infer<typeof QuietHoursSchema>;

export const UserNotificationPrefsSchema = z.object({
  user_id: z.string().uuid(),
  quiet_hours: QuietHoursSchema.default({ start: '22:00', end: '08:00' }),
  channel: z.string().default('push'),
  enabled: z.boolean().default(true),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type UserNotificationPrefs = z.infer<typeof UserNotificationPrefsSchema>;

export const UserNotificationPrefsInsertSchema = UserNotificationPrefsSchema.omit({
  created_at: true,
  updated_at: true,
}).partial({
  quiet_hours: true,
  channel: true,
  enabled: true,
});

export type UserNotificationPrefsInsert = z.infer<typeof UserNotificationPrefsInsertSchema>;

// ----------------------------------------------------------------------------
// Link Notification Preferences
// ----------------------------------------------------------------------------
export const PhaseTransitionsSchema = z.object({
  follicular: z.boolean().default(true),
  ovulation: z.boolean().default(true),
  luteal: z.boolean().default(true),
  pms: z.boolean().default(true),
});

export type PhaseTransitions = z.infer<typeof PhaseTransitionsSchema>;

export const LinkNotificationPrefsSchema = z.object({
  link_id: z.string().uuid(),
  critical_window: z.boolean().default(true),
  t_minus_3: z.boolean().default(true),
  on_start: z.boolean().default(true),
  on_mid: z.boolean().default(true),
  on_end: z.boolean().default(true),
  phase_transitions: PhaseTransitionsSchema.default({
    follicular: true,
    ovulation: true,
    luteal: true,
    pms: true,
  }),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type LinkNotificationPrefs = z.infer<typeof LinkNotificationPrefsSchema>;

export const LinkNotificationPrefsInsertSchema = LinkNotificationPrefsSchema.omit({
  created_at: true,
  updated_at: true,
}).partial({
  critical_window: true,
  t_minus_3: true,
  on_start: true,
  on_mid: true,
  on_end: true,
  phase_transitions: true,
});

export type LinkNotificationPrefsInsert = z.infer<typeof LinkNotificationPrefsInsertSchema>;

// ----------------------------------------------------------------------------
// Notifications Queue
// ----------------------------------------------------------------------------
export const NotificationSchema = z.object({
  id: z.number(),
  link_id: z.string().uuid().nullable(),
  male_user: z.string().uuid(),
  female_user: z.string().uuid(),
  kind: z.string(),
  scheduled_at: z.string().datetime(),
  payload: z.record(z.string(), z.any()).default({}),
  status: z.string().default('pending'),
  sent_at: z.string().datetime().nullable(),
  created_at: z.string().datetime(),
});

export type Notification = z.infer<typeof NotificationSchema>;

export const NotificationInsertSchema = NotificationSchema.omit({
  id: true,
  created_at: true,
}).partial({
  link_id: true,
  payload: true,
  status: true,
  sent_at: true,
});

export type NotificationInsert = z.infer<typeof NotificationInsertSchema>;

// ----------------------------------------------------------------------------
// Translation
// ----------------------------------------------------------------------------
export const TranslationSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  locale: Locale,
  value: z.string(),
  context: z.string().nullable(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export type Translation = z.infer<typeof TranslationSchema>;

export const TranslationInsertSchema = TranslationSchema.omit({
  id: true,
  created_at: true,
  updated_at: true,
}).partial({
  context: true,
});

export type TranslationInsert = z.infer<typeof TranslationInsertSchema>;

// ============================================================================
// HELPER TYPES
// ============================================================================

/**
 * Database response type wrapper
 */
export type DbResult<T> = {
  data: T | null;
  error: Error | null;
};

/**
 * Pagination options
 */
export type PaginationOptions = {
  page?: number;
  limit?: number;
};

/**
 * Date range filter
 */
export type DateRange = {
  from: string;
  to: string;
};
