# 🌸 BabeCycle - Complete Project Implementation Plan

> **Language Note**: Project is developed in **English by default**. i18n infrastructure is built-in for future language expansion (Turkish, Spanish, French, Arabic, etc.)

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Working Methodology](#working-methodology)
4. [Phase 0: Foundation Setup](#phase-0-foundation-setup)
5. [Phase 1: Database & Infrastructure](#phase-1-database--infrastructure)
6. [Phase 2: UI Component Library](#phase-2-ui-component-library)
7. [Phase 3: Female User Flow](#phase-3-female-user-flow)
8. [Phase 4: Male User Flow](#phase-4-male-user-flow)
9. [Phase 5: Notification Engine](#phase-5-notification-engine)
10. [Phase 6: Testing & Quality](#phase-6-testing--quality)
11. [Phase 7: Deployment](#phase-7-deployment)
12. [i18n Architecture](#i18n-architecture)
13. [Success Metrics](#success-metrics)
14. [Timeline](#timeline)

---

## Project Overview

**BabeCycle** is a modern, privacy-first menstrual cycle tracking application with unique partner sharing features.

### Key Features
- **Dual Account System**: Female (tracker) and Male (supporter) roles
- **Multi-partner Support**: One user can link with multiple partners
- **Flexible Privacy**: Granular sharing controls (phase-only vs. phase+dates)
- **Smart Notifications**: Context-aware, timezone-smart notification system
- **Cycle Overwrite**: Safe historical correction with audit trail
- **i18n Ready**: Multi-language support infrastructure from day one

### Core Principles
- **Mobile-first**: Optimized for mobile devices
- **Privacy-first**: No third-party SDKs, minimal data collection
- **Empathy-driven**: UI/UX designed for emotional sensitivity
- **Timezone-aware**: Proper handling of global users
- **Offline-capable**: Progressive Web App features

---

## Tech Stack

### Frontend
- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 4
- **UI Components**: shadcn/ui
- **Animations**: Framer Motion
- **Icons**: Lucide React
- **Charts**: Recharts
- **i18n**: next-intl (with ICU message format)

### Backend
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Real-time**: Supabase Realtime
- **Storage**: Supabase Storage (for photos)
- **API**: Next.js API Routes
- **Cron**: Vercel Cron

### Infrastructure
- **Hosting**: Vercel
- **CDN**: Vercel Edge Network
- **Monitoring**: Vercel Analytics (privacy-friendly)
- **Error Tracking**: Sentry (optional, privacy-configured)

### Developer Tools
- **Testing**: Vitest + Playwright
- **Type Safety**: TypeScript + Zod
- **Linting**: ESLint + Prettier
- **Git**: Conventional Commits
- **CI/CD**: GitHub Actions + Vercel

---

## Working Methodology

### Sprint Ritual
Each sprint follows this process:
1. **Mini-plan**: Define 1-2 deliverables
2. **Single prompt = Complete feature**: One detailed prompt per feature
3. **DoD checklist**: Verify completion criteria
4. **Auto-documentation**: Update `/docs` automatically

### Branch & Commit Convention
- **Branch naming**: `feat/<feature-name>` (e.g., `feat/db-schema-v1`)
- **Commit format**:
  - `feat(scope): description` - New features
  - `fix(scope): description` - Bug fixes
  - `chore(scope): description` - Maintenance
  - `docs(scope): description` - Documentation
  - Example: `feat(db): add cycles table + RLS policies`

### Code Prompt Principles
- Provide **full file paths** and **endpoint names**
- Define **success conditions** and **rejection criteria**
- List **files to be modified**
- Include **test commands**
- Specify **DoD checklist items**

---

## Phase 0: Foundation Setup

### 0.1 UI-UX Design System

**Objective**: Establish BabeCycle's visual identity and component standards.

**Deliverables**:
1. `/docs/UI_UX_GUIDE.md` - Complete design system documentation
2. `tailwind.config.ts` - BabeCycle color palette and theme
3. `/components/ui/` - shadcn/ui base components with BabeCycle styling
4. Framer Motion setup
5. Lucide React icons

**Color Palette**:
```typescript
// Default English UI (no hard-coded Turkish text)
colors: {
  blush: '#F7CBD0',      // Female theme accent
  sage: '#C8D8B6',       // Male theme accent
  mauve: '#C5A8E2',      // Neutral/shared accent
  linen: '#F9F8F5',      // Background
  ink: '#2B2B2B',        // Text
  dusty: '#999999',      // Secondary text
  plum: '#4A335B',       // Dark mode background
  coral: '#FF8360'       // Critical alerts
}
```

**Typography**:
- Primary: Inter (400, 600, 700)
- Monospace: DM Mono (for dates/numbers)
- All labels in English: "Period Started", "Critical Window", etc.

**DoD**:
- [ ] `tailwind.config.ts` compiles successfully
- [ ] shadcn/ui components render with BabeCycle theme
- [ ] Dark mode toggle functional
- [ ] All text in English (no Turkish content)
- [ ] Design system documented

**Files**:
- `docs/UI_UX_GUIDE.md`
- `tailwind.config.ts`
- `components/ui/*`

---

### 0.2 Project Structure & i18n Infrastructure

**Objective**: Reorganize project for BabeCycle and set up i18n-ready architecture.

**Deliverables**:

1. **Library Structure**:
```
/lib
├── i18n/
│   ├── index.ts              # i18n utilities
│   ├── config.ts             # Supported locales config
│   ├── server.ts             # Server-side i18n
│   ├── client.ts             # Client-side i18n
│   └── locales/
│       ├── en/
│       │   ├── common.json   # Common translations
│       │   ├── phases.json   # Phase names
│       │   ├── symptoms.json # Symptom names
│       │   └── notifications.json
│       ├── tr/               # Turkish (future)
│       ├── es/               # Spanish (future)
│       ├── fr/               # French (future)
│       └── ar/               # Arabic (future, RTL)
├── timezone.ts               # TZ detection & conversion
├── analytics.ts              # Privacy-first analytics
├── phase.ts                  # Cycle phase calculations
├── notify/                   # Notification engine
│   ├── engine.ts
│   ├── context.ts
│   ├── rules.ts
│   └── templates.ts
└── dates.ts                  # Date utilities
```

2. **Type Definitions**:
```
/types
├── user.ts
├── cycle.ts
├── partner.ts
├── notification.ts
└── i18n.ts                   # Translation types
```

3. **i18n Configuration**:
```typescript
// lib/i18n/config.ts
export const i18n = {
  defaultLocale: 'en',
  locales: ['en', 'tr', 'es', 'fr', 'ar'],
  localeDetection: true,
  rtlLocales: ['ar']
} as const;

export type Locale = typeof i18n.locales[number];
```

4. **Database i18n Support**:
```sql
-- Add locale column to profiles
ALTER TABLE profiles
ADD COLUMN locale text DEFAULT 'en' CHECK (locale IN ('en','tr','es','fr','ar'));

-- Create translations table (for future dynamic content)
CREATE TABLE translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL,
  locale text NOT NULL,
  value text NOT NULL,
  context text,
  created_at timestamptz DEFAULT now(),
  UNIQUE (key, locale)
);
```

5. **Translation File Structure** (English only initially):
```json
// lib/i18n/locales/en/common.json
{
  "welcome": "Welcome to BabeCycle",
  "loading": "Loading...",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "edit": "Edit",
  "confirm": "Confirm"
}

// lib/i18n/locales/en/phases.json
{
  "menstrual": "Menstrual",
  "follicular": "Follicular",
  "ovulation": "Ovulation",
  "luteal": "Luteal",
  "pms": "PMS"
}

// lib/i18n/locales/en/notifications.json
{
  "t_minus_3": "Your period may start in 3 days",
  "period_started": "Your period started today 🌸 Be gentle with yourself",
  "period_mid": "Midway through your period, don't forget to rest",
  "period_ended": "Period complete 💫 Ready for new energy"
}
```

**DoD**:
- [ ] i18n utilities functional
- [ ] Default locale is 'en'
- [ ] Translation files structured
- [ ] Database supports locale storage
- [ ] Type safety for translations
- [ ] **All UI text in English** (no Turkish content)
- [ ] Future language expansion ready

**Files**:
- `lib/i18n/**/*`
- `lib/timezone.ts`
- `lib/analytics.ts`
- `types/**/*`
- `supabase/migrations/*_add_locale.sql`

---

## Phase 1: Database & Infrastructure

### 1.1 Database Schema + RLS + Seed

**Objective**: Create complete database schema with multi-language support.

**Copy-Paste Prompt**:
```
Objective: Create BabeCycle Supabase schema with RLS policies and i18n support.

Requirements:
- User roles: female|male
- Multi-partner support (N:N): partner_links with share_scope
- Cycle tracking: cycles table with overwrite audit (cycle_corrections)
- Daily logs: symptoms, mood, notes
- Notifications: user_notification_prefs, link_notification_prefs, notifications_queue
- i18n: locale column in profiles, translations table for future
- All RLS policies enabled
- All text content in English

Generate:

1) supabase/migrations/20251108_init_babecycle.sql
   ENUMs:
   - user_role: 'female' | 'male'
   - share_scope: 'phase_only' | 'phase_plus_dates'
   - link_status: 'pending' | 'active' | 'revoked'
   - event_kind: 'period_start' | 'period_end' | 'note'
   - phase_type: 'menstrual' | 'follicular' | 'ovulation' | 'luteal' | 'pms'

   Tables:

   profiles:
   - user_id uuid PK (references auth.users)
   - role user_role NOT NULL
   - display_name text
   - tz text DEFAULT 'UTC'
   - locale text DEFAULT 'en' CHECK (locale IN ('en','tr','es','fr','ar'))
   - created_at timestamptz DEFAULT now()

   cycles:
   - id bigserial PK
   - user_id uuid FK (profiles)
   - start_date date NOT NULL
   - end_date date
   - source text DEFAULT 'manual'
   - version int DEFAULT 1
   - is_active boolean GENERATED (end_date IS NULL) STORED
   - created_at timestamptz DEFAULT now()

   cycle_corrections:
   - id bigserial PK
   - cycle_id bigint FK (cycles)
   - user_id uuid FK (profiles)
   - prev_start date
   - prev_end date
   - new_start date
   - new_end date
   - reason text
   - created_at timestamptz DEFAULT now()

   daily_logs:
   - id bigserial PK
   - user_id uuid FK (profiles)
   - date date NOT NULL
   - mood text
   - symptoms jsonb
   - notes text
   - created_at timestamptz DEFAULT now()
   - UNIQUE (user_id, date)

   partner_links:
   - id uuid PK DEFAULT gen_random_uuid()
   - female_user uuid FK (profiles)
   - male_user uuid FK (profiles)
   - status link_status DEFAULT 'pending'
   - share_scope share_scope DEFAULT 'phase_only'
   - invite_code text
   - invite_expires_at timestamptz
   - created_at timestamptz DEFAULT now()
   - UNIQUE (female_user, male_user, status)

   user_notification_prefs:
   - user_id uuid PK FK (profiles)
   - quiet_hours jsonb DEFAULT '{"start":"22:00","end":"08:00"}'
   - channel text DEFAULT 'push'

   link_notification_prefs:
   - link_id uuid PK FK (partner_links)
   - critical_window boolean DEFAULT true
   - t_minus_3 boolean DEFAULT true
   - on_start boolean DEFAULT true
   - on_mid boolean DEFAULT true
   - on_end boolean DEFAULT true
   - phase_transitions jsonb DEFAULT '{"follicular":true,"ovulation":true,"luteal":true,"pms":true}'

   notifications_queue:
   - id bigserial PK
   - link_id uuid FK (partner_links)
   - male_user uuid FK (profiles)
   - female_user uuid FK (profiles)
   - kind text NOT NULL
   - scheduled_at timestamptz NOT NULL
   - payload jsonb
   - status text DEFAULT 'pending'
   - created_at timestamptz DEFAULT now()

   translations (for future dynamic content):
   - id uuid PK DEFAULT gen_random_uuid()
   - key text NOT NULL
   - locale text NOT NULL
   - value text NOT NULL
   - context text
   - created_at timestamptz DEFAULT now()
   - UNIQUE (key, locale)

   Indexes:
   - cycles: (user_id, start_date)
   - daily_logs: (user_id, date)
   - partner_links: (female_user, male_user, status)
   - notifications_queue: (male_user, scheduled_at, status)
   - translations: (key, locale)

   RLS Policies:
   - profiles: owner read/write
   - cycles/daily_logs/cycle_corrections: owner only
   - partner_links: female_user OR male_user read; update only by owner role
   - notifications_queue: link members only
   - translations: public read, admin write (future role)

   View: partner_cycle_view
   - Share-scope aware view for male users
   - Shows phase + dates only if share_scope = 'phase_plus_dates'

2) supabase/seed.sql (English content only)
   - 2 female users: alice@test.com, bella@test.com
   - 2 male users: charlie@test.com, david@test.com
   - All users locale = 'en', tz = 'America/New_York'
   - Display names in English: "Alice", "Bella", "Charlie", "David"
   - 2 active links:
     * alice <-> charlie (phase_only)
     * bella <-> david (phase_plus_dates)
   - 1 pending link
   - Sample cycles (last 3 months)
   - Sample daily_logs with English notes
   - Sample notification preferences

3) lib/db/schema.ts
   - TypeScript types generated from schema
   - Zod validators

4) README-DB-NOTES.md
   - Overwrite flow explanation
   - Multi-link & share_scope logic
   - i18n database design rationale
   - RLS test queries (psql examples)

5) Update docs:
   - docs/DATABASE.md (full schema + relationships)
   - docs/CHANGES.md (2025-11-08 entry)
   - docs/SESSIONS.md

Acceptance Criteria:
- [ ] Migration runs with zero errors
- [ ] RLS prevents unauthorized cross-user reads
- [ ] partner_cycle_view respects share_scope
- [ ] Seed imports successfully
- [ ] All content in English
- [ ] locale column exists and defaults to 'en'
- [ ] translations table ready for future expansion
- [ ] TypeScript types generated

Files to modify:
- supabase/migrations/20251108_init_babecycle.sql
- supabase/seed.sql
- lib/db/schema.ts
- README-DB-NOTES.md
- docs/DATABASE.md
- docs/CHANGES.md
- docs/SESSIONS.md

Test command:
```bash
supabase db reset  # local
supabase db push   # remote
npm run type-check
```
```

**DoD**:
- [ ] Migration successful
- [ ] RLS tested (no violations)
- [ ] Seed data imported
- [ ] TypeScript types work
- [ ] All content in English
- [ ] i18n infrastructure ready

---

### 1.2 Timezone & Locale System

**Objective**: Production-grade timezone handling and locale management.

**Deliverables**:

1. **Timezone Utilities** (`/lib/timezone.ts`):
```typescript
// All function names and comments in English
export function detectUserTimezone(): string;
export function convertToUserTZ(date: Date, targetTZ: string): Date;
export function normalizeToUTC(localDate: Date, userTZ: string): Date;
export function getTimezoneOffset(tz: string): number;
export function isDST(date: Date, tz: string): boolean;
export function scheduleInUserTZ(event: Date, userTZ: string): Date;
export function formatInTZ(date: Date, tz: string, format: string): string;
```

2. **i18n Utilities** (`/lib/i18n/index.ts`):
```typescript
// All in English
export function getLocale(): string;
export function setLocale(locale: Locale): void;
export function t(key: string, params?: Record<string, any>): string;
export function formatDate(date: Date, format: string, locale?: Locale): string;
export function formatNumber(num: number, locale?: Locale): string;
```

3. **Onboarding Updates**:
   - Add timezone selector (auto-detected, can override)
   - Add language selector (default 'en', show all future options grayed out)
   - Save to `profiles.tz` and `profiles.locale`

**DoD**:
- [ ] TZ detection works (browser + server)
- [ ] Notifications schedule in correct TZ
- [ ] Language switching infrastructure ready (only 'en' active)
- [ ] Date formats respect locale
- [ ] All UI text in English

**Files**:
- `lib/timezone.ts`
- `lib/i18n/**/*`
- `app/onboarding/page.tsx`

---

## Phase 2: UI Component Library

### 2.1 Core BabeCycle Components

**Objective**: Build reusable, branded UI components (all English labels).

**Copy-Paste Prompt**:
```
Objective: Create BabeCycle-specific UI components with English labels.

Generate:

1) /components/babecycle/
   Components (all text in English):

   PhaseTag.tsx:
   - Props: phase ('menstrual'|'follicular'|'ovulation'|'luteal'|'pms')
   - Display: colored tag with icon + English label
   - Colors: blush (M), sage (F/L), coral (O/PMS)

   QuickAction.tsx:
   - Buttons: "Period Started", "Period Ended", "Add Symptom"
   - Haptic feedback on tap
   - Disabled states

   MoodPicker.tsx:
   - Emoji grid (😊😐😔😢😡)
   - English labels: "Happy", "Neutral", "Sad", "Crying", "Angry"
   - Selected state with scale animation

   SymptomChip.tsx:
   - Interactive tags for symptoms
   - English labels: "Cramps", "Headache", "Bloating", "Fatigue"
   - Severity levels: "Mild", "Moderate", "Severe"

   CalendarDay.tsx:
   - Day cell for calendar grid
   - Phase-colored dots
   - Today highlight
   - Selected state

   PartnerCard.tsx:
   - Partner info display
   - Avatar + name
   - Share scope badge: "Phase Only" | "Phase + Dates"
   - Quick actions: "Mute", "Unlink"

   NotificationToggle.tsx:
   - Switch with English label
   - Description text
   - Disabled state explanation

   EmptyState.tsx:
   - Icon + English message
   - CTA button
   - Examples:
     * "No partners yet" + "Add a partner"
     * "No logs yet" + "Start tracking"

   LoadingState.tsx:
   - Skeleton screens
   - Shimmer effect
   - Respects dark mode

2) /lib/motion/presets.ts
   - Framer Motion variants
   - fadeIn, slideUp, scaleIn
   - Durations: <250ms

3) Each component:
   - Fully typed props
   - Dark mode support
   - Mobile-optimized (min 44px touch targets)
   - Accessibility (ARIA labels in English)
   - Storybook story (optional)

DoD:
- [ ] All components render
- [ ] Colors match UI_UX_GUIDE.md
- [ ] Animations smooth
- [ ] All text in English
- [ ] Dark mode works
- [ ] Touch targets ≥44px
- [ ] Type-safe

Files:
- components/babecycle/**/*
- lib/motion/presets.ts
```

**DoD**:
- [ ] Components library complete
- [ ] Storybook accessible (optional)
- [ ] All labels English
- [ ] Dark mode tested

---

### 2.2 Layout System

**Objective**: Role-aware navigation (English labels).

**Prompt**:
```
Objective: Create role-based layouts with English navigation.

Generate:

1) /components/layout/

   AppLayout.tsx:
   - Main container
   - English page titles
   - Dark mode toggle

   FemaleTabBar.tsx:
   - Tabs: "Home", "Calendar", "Log", "Insights", "Partners", "Settings"
   - Icons from Lucide
   - Active state

   MaleTabBar.tsx:
   - Tabs: "Home", "Calendar", "Notifications", "Partners", "Settings"
   - Icons from Lucide

   TopBar.tsx:
   - Partner selector (male): "Select Partner"
   - Date picker (calendar): English month names
   - Back button: "Back"

   MobileNav.tsx:
   - Hamburger menu
   - Profile section: "View Profile"
   - Language selector (future): grayed out "Language: English"

2) /lib/hooks/
   - useRole(): 'female' | 'male'
   - usePartners(): Partner[]
   - useCurrentPhase(): Phase
   - useNotifications(): Notification[]
   - useTranslation(): (key: string) => string

3) middleware.ts updates:
   - Role-based redirects
   - Onboarding check
   - Locale detection (set header)

DoD:
- [ ] Tab bars render per role
- [ ] Navigation state persists
- [ ] All labels English
- [ ] Mobile responsive
- [ ] Dark mode support

Files:
- components/layout/**/*
- lib/hooks/**/*
- middleware.ts
```

**DoD**:
- [ ] Layouts functional
- [ ] Navigation works
- [ ] English labels only
- [ ] Role-aware rendering

---

## Phase 3: Female User Flow

### 3.1 Dashboard (Female)

**Prompt**:
```
Objective: Female dashboard with English content.

Generate:
1) /app/dashboard/page.tsx (female variant)
   - English titles: "Today's Overview", "Quick Actions", "Upcoming"
   - Phase card with English phase names
   - Buttons: "Period Started", "Period Ended", "Log Symptom"
   - Streak counter: "X days logged"

2) Components (all English):
   - TodayCard.tsx: "Today: Follicular Phase"
   - QuickActions.tsx: Button labels in English
   - PhaseRing.tsx: English phase labels
   - UpcomingEvents.tsx: "Period expected in X days"

DoD:
- [ ] Phase calculated
- [ ] Actions work
- [ ] Real-time updates
- [ ] All text English
- [ ] Skeleton loading

Files: app/dashboard/page.tsx, components/dashboard/**/*
```

**Continue similar pattern for**:
- 3.2 Calendar (Female) - English: "Edit Date", "Period Started", "Predicted"
- 3.3 Log (Daily Tracking) - English: "Mood", "Symptoms", "Notes", "Save Log"
- 3.4 Insights (Analytics) - English: "Average Cycle", "Regularity Score", "Export"
- 3.5 Partners (Female) - English: "Add Partner", "Invite Code", "Share Settings"
- 3.6 Notifications (Female) - English: "Notification Preferences", "Quiet Hours"

**All prompts follow same structure**:
- ✅ English-only UI text
- ✅ Translation keys defined (for future)
- ✅ i18n-ready structure
- ✅ No hard-coded Turkish content

---

## Phase 4: Male User Flow

(Same structure as Phase 3, all English)

- 4.1 Dashboard (Male) - "Partner Overview", "Today's Phase"
- 4.2 Calendar (Male) - "View Partner Calendar", "Critical Period"
- 4.3 Notifications (Male) - "Notification Settings", "Per-Partner Alerts"
- 4.4 Tips - "Communication Tips", "Phase Guide"

---

## Phase 5: Notification Engine

**English notification templates**:
```typescript
// lib/notify/templates.ts
export const templates = {
  en: {
    t_minus_3: "Period may start in 3 days",
    period_started: "Period started today 🌸",
    period_mid: "Midway through period",
    period_ended: "Period completed 💫",
    // ... all in English
  },
  // tr, es, fr, ar: empty objects for future
};
```

---

## i18n Architecture

### Translation File Structure
```
/lib/i18n/locales/
├── en/                    # ACTIVE (complete translations)
│   ├── common.json        # Buttons, labels, actions
│   ├── phases.json        # Phase names
│   ├── symptoms.json      # Symptom names
│   ├── notifications.json # Notification templates
│   ├── tips.json          # Male user tips
│   └── errors.json        # Error messages
├── tr/                    # FUTURE (empty/placeholder)
│   ├── common.json
│   └── ...
├── es/                    # FUTURE
├── fr/                    # FUTURE
└── ar/                    # FUTURE (RTL support needed)
```

### Translation Keys Convention
```typescript
// Use nested dot notation
t('common.save')           // "Save"
t('phases.menstrual')      // "Menstrual"
t('notifications.t_minus_3') // "Period may start in 3 days"
t('symptoms.cramps')       // "Cramps"
```

### Database i18n Strategy
```sql
-- User preference
profiles.locale: 'en' | 'tr' | 'es' | 'fr' | 'ar'

-- Dynamic content (future)
translations (key, locale, value)
  - Allows admin-panel content translation
  - Not needed for MVP
```

### Component i18n Pattern
```tsx
// ALL components use English text directly in MVP
// i18n infrastructure ready for future

// CURRENT (MVP):
<Button>Save</Button>

// FUTURE (when activating i18n):
<Button>{t('common.save')}</Button>
```

### Locale Detection Flow
```
1. Check user profile (profiles.locale)
2. Fallback to browser language
3. Fallback to 'en' (default)
4. Render UI in detected locale
```

### Adding New Language (Future Process)
1. Create `/lib/i18n/locales/{locale}/` folder
2. Copy English JSON files
3. Translate all keys
4. Add locale to `i18n.config.ts`
5. Update database CHECK constraint
6. Deploy
7. Users see new language option

---

## Success Metrics

### Technical KPIs
- Build time: <2 min
- Bundle size: <500 KB (first load)
- API response: <200ms (p95)
- Lighthouse score: >90
- Test coverage: >70%
- Zero RLS violations

### User Experience KPIs
- Onboarding completion: >80%
- Daily logging rate: >60%
- Partner link success: >90%
- Notification CTR: >40%
- Session duration: >5 min avg

### Quality KPIs
- Zero critical bugs in production
- Uptime: >99.9%
- Error rate: <0.1%
- User satisfaction: >4.5/5

---

## Timeline

### Week 1: Foundation + Female Flow
- **Day 1-2**: Phase 0 (Design System + i18n Infrastructure)
- **Day 3-4**: Phase 1 (Database + RLS)
- **Day 5-7**: Phase 2-3 (Components + Female Flow)

### Week 2: Male Flow + Notifications
- **Day 8-10**: Phase 4 (Male User Flow)
- **Day 11-14**: Phase 5 (Notification Engine + Cron)

### Week 3: Testing + Deployment
- **Day 15-17**: Phase 6 (Testing + Optimization)
- **Day 18-21**: Phase 7 (Production Deployment + Monitoring)

### Post-Launch (Future)
- **Month 2+**: Add Turkish (tr) translations
- **Month 3+**: Add Spanish (es), French (fr)
- **Month 6+**: Add Arabic (ar) with RTL support

---

## Documentation Auto-Update Rules

After each completed prompt/feature:

1. **docs/CHANGES.md**: Add dated entry with changes
2. **docs/SESSIONS.md**: Log session work
3. **docs/API.md**: Update if API endpoints added
4. **docs/DATABASE.md**: Update if schema changed
5. **docs/ARCHITECTURE.md**: Update if architecture evolved

---

## Important Notes

### Language Policy
- ✅ **All UI text in English** (MVP)
- ✅ **All code comments in English**
- ✅ **All documentation in English**
- ✅ **All commit messages in English**
- ✅ **i18n infrastructure ready** for future expansion
- ✅ **Database supports locale** column
- ✅ **Translation files structured** (only 'en' populated)
- ❌ **NO Turkish content** in codebase (we can communicate in Turkish, but all code/UI in English)

### i18n Readiness Checklist
- [ ] `profiles.locale` column exists
- [ ] `translations` table created (for future)
- [ ] `/lib/i18n/` utilities functional
- [ ] Translation files structured (`en` complete, others empty)
- [ ] All components use English text directly
- [ ] Future locale expansion documented
- [ ] RTL support architecture planned (for Arabic)

### Privacy & Security
- ❌ NO third-party analytics/ad SDKs
- ✅ Privacy-first telemetry only
- ✅ End-to-end encryption for messages
- ✅ Granular data sharing controls
- ✅ GDPR/CCPA compliance tools
- ✅ Audit logs for all data access

---

## Getting Started

### Prerequisites
```bash
Node.js v18+
npm v9+
Supabase CLI
Vercel CLI
```

### Initial Setup
```bash
# Clone and install
git clone <repo>
cd sarpproject
npm install

# Supabase setup
supabase init
supabase db reset
supabase db push

# Environment
cp .env.local.example .env.local
# Add Supabase credentials

# Development
npm run dev
```

### First Sprint (Prompt #1)
Start with Phase 1.1 (Database Schema + RLS + Seed) prompt above.

---

## Contact & Support

- **GitHub Issues**: For bug reports and feature requests
- **Documentation**: All docs in `/docs` folder
- **i18n Contributions**: Translation files welcome (future)

---

**Last Updated**: 2025-11-08
**Version**: 1.0.0 (MVP - English Only)
**Next Milestone**: Turkish (tr) translation activation
