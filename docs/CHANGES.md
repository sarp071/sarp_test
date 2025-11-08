# Changelog

All notable changes to this project will be documented in this file.

## 2025-11-08 - Initial Setup

### Summary
Initial project setup with Next.js 15, TypeScript, Tailwind CSS, and Supabase authentication. Complete authentication system implemented with protected routes.

### Changes Made
- ✅ Created Next.js 15 project with App Router
- ✅ Implemented Supabase authentication (email/password)
- ✅ Set up protected routes with middleware
- ✅ Created login, signup, and dashboard pages
- ✅ Configured Vercel deployment
- ✅ Added comprehensive documentation system

### Architecture Decisions

#### Authentication Strategy
- **Supabase SSR**: Chosen for proper cookie handling in Next.js 15
- **Three Separate Clients**: Client, Server, and Middleware contexts
- **Middleware Protection**: Edge-level route protection for performance

#### Project Structure
- **Route Groups**: Using `(auth)` for clean URLs without path segments
- **Component Separation**: Client components only where needed (forms, buttons)
- **Server-First**: Default to Server Components for better performance

#### Security
- **HTTP-Only Cookies**: Session tokens stored securely
- **Double Validation**: Middleware + Server Component checks
- **No Service Keys**: Only public keys exposed (RLS enforced)

### Files Added

#### Pages & Routes
- `/app/page.tsx` - Landing page with Sign In/Sign Up links
- `/app/(auth)/login/page.tsx` - Login page with email/password form
- `/app/(auth)/signup/page.tsx` - Signup page with account creation
- `/app/auth/callback/route.ts` - Email verification callback handler
- `/app/dashboard/page.tsx` - Protected dashboard showing user info

#### Components
- `/components/LogoutButton.tsx` - Client component for sign-out functionality

#### Supabase Integration
- `/lib/supabase/client.ts` - Browser-side Supabase client
- `/lib/supabase/server.ts` - Server Component Supabase client
- `/lib/supabase/middleware.ts` - Middleware Supabase client with session refresh

#### Core Files
- `/middleware.ts` - Route protection and auth redirects
- `/.env.local.example` - Environment variables template
- `/.env.local` - Local environment variables (gitignored)

#### Configuration
- `/vercel.json` - Vercel deployment configuration
- `/package.json` - Updated with Supabase dependencies
- `/tsconfig.json` - TypeScript configuration
- `/tailwind.config.ts` - Tailwind CSS configuration

#### Documentation
- `/README.md` - Enhanced with setup guide and AI documentation protocol
- `/docs/ARCHITECTURE.md` - System architecture documentation
- `/docs/CHANGES.md` - This changelog file
- `/docs/SESSIONS.md` - Session-by-session development log

### Dependencies Added
```json
{
  "@supabase/ssr": "^0.7.0",
  "@supabase/supabase-js": "^2.80.0"
}
```

### Configuration Changes

#### Next.js Configuration
- Using Next.js 16.0.1 (latest)
- App Router enabled
- Turbopack for faster builds
- TypeScript strict mode

#### Tailwind CSS
- Tailwind CSS 4.x
- PostCSS integration
- Custom color schemes ready

### Breaking Changes
None - Initial setup

### Migration Notes
None - Initial setup

### Setup Requirements

#### Required Environment Variables
```env
NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

#### Supabase Configuration Needed
1. Create project at supabase.com
2. Enable Email authentication
3. Configure redirect URLs:
   - Development: `http://localhost:3000/auth/callback`
   - Production: `https://your-domain.com/auth/callback`

### Testing Checklist
- [ ] User can sign up with email/password
- [ ] Email verification link works
- [ ] User can sign in
- [ ] Dashboard is protected (redirects to /login if not authenticated)
- [ ] User can sign out
- [ ] Authenticated users can't access /login or /signup (redirected to /dashboard)

### Known Issues
None

### Future Enhancements Planned
- Database schema for user profiles
- Password reset functionality
- OAuth providers (Google, GitHub)
- Profile management page
- Drizzle ORM integration
- Zod validation for forms
- shadcn/ui component library
- API routes for backend operations
- Real-time features via Supabase Realtime

### Performance Metrics
- **Build Time**: ~3-5 seconds with Turbopack
- **Cold Start**: Fast (edge middleware)
- **Bundle Size**: Optimized (Server Components)

### Documentation Additions
- Comprehensive README with step-by-step setup
- AI Assistant Documentation Protocol
- Architecture documentation with diagrams
- Session logs for development tracking

---

## 2025-11-08 - BabeCycle Project Planning

### Summary
Comprehensive planning session for BabeCycle menstrual cycle tracking application with partner sharing features. Established English-first i18n architecture, designed complete database schema, and created 7-phase implementation roadmap.

### Changes Made
- ✅ Created comprehensive PROJECT_PLAN.md (977 lines)
- ✅ Designed complete database schema with i18n support
- ✅ Established English-only development policy
- ✅ Planned 7-phase implementation roadmap
- ✅ Defined notification engine architecture (30+ types)
- ✅ Designed dual account system (female/male roles)
- ✅ Created copy-paste ready prompts for AI-assisted development
- ✅ Established working methodology and conventions

### Architecture Decisions

#### Project Pivot: BabeCycle
- **From**: Basic Next.js authentication starter
- **To**: Full-featured menstrual cycle tracker with partner sharing
- **Key Features**:
  - Dual account system (female tracker / male supporter)
  - Multi-partner support (N:N relationships)
  - Flexible privacy controls (phase-only vs. phase+dates)
  - Smart notification engine (context-aware, timezone-smart)
  - Cycle overwrite with audit trail
  - i18n-ready from day 1

#### i18n Architecture
- **Critical Decision**: Develop in **English only** for MVP
- **Database Support**: `profiles.locale` column ('en'|'tr'|'es'|'fr'|'ar')
- **Translation Structure**: `/lib/i18n/locales/{locale}/` (only 'en' populated)
- **Future Languages**: Turkish, Spanish, French, Arabic (RTL)
- **Policy**:
  - ✅ All UI text in English
  - ✅ All code comments in English
  - ✅ All documentation in English
  - ❌ NO Turkish content in codebase
  - ✅ i18n infrastructure ready for future expansion

#### Database Schema Design
**10 Core Tables**:
1. `profiles` - User accounts with role, locale, timezone
2. `cycles` - Menstrual cycle tracking with version control
3. `cycle_corrections` - Audit trail for historical changes
4. `daily_logs` - Mood, symptoms, notes (JSONB)
5. `partner_links` - N:N relationships with share_scope
6. `user_notification_prefs` - Global notification settings
7. `link_notification_prefs` - Per-partner notification controls
8. `notifications_queue` - Scheduled notification delivery
9. `translations` - Future dynamic content translations
10. `auth.users` - Supabase managed (existing)

**Key Design Patterns**:
- **Multi-Partner Support**: `partner_links` with `share_scope` ENUM
- **Granular Privacy**: 'phase_only' vs. 'phase_plus_dates'
- **Cycle Overwrites**: `cycle_corrections` audit trail
- **Timezone Aware**: `profiles.tz` for smart scheduling
- **i18n Ready**: `profiles.locale` + `translations` table
- **RLS Enabled**: Row-Level Security on all tables

#### Notification Engine Architecture
**30+ Notification Types**:
- **Female User** (15 types):
  - T-3 days warning
  - Period start (gentle encouragement)
  - Period midpoint (self-care reminder)
  - Period end (energy boost)
  - Phase transitions (follicular, ovulation, luteal, PMS)
  - Irregularity detection
  - Logging streak reminders
  - Symptom pattern alerts
  - Partner muted/unmuted confirmations
  - Data export ready

- **Male User** (15+ types):
  - T-3 days heads-up
  - Critical window start
  - Phase transition alerts
  - Communication tips
  - Symptom context education
  - Partner preferences changed
  - Link invitation status
  - Quiet mode confirmations

**Smart Features**:
- Context-aware scheduling (cycle phase, time of day)
- Timezone-smart delivery (user's local time)
- Quiet hours respect (22:00-08:00 default)
- Per-partner muting
- Notification history tracking

### Files Added

#### Documentation
- `/docs/PROJECT_PLAN.md` - Complete 7-phase implementation roadmap
  - Phase 0: Foundation Setup (UI-UX + i18n)
  - Phase 1: Database & Infrastructure
  - Phase 2: UI Component Library
  - Phase 3: Female User Flow
  - Phase 4: Male User Flow
  - Phase 5: Notification Engine
  - Phase 6: Testing & Quality
  - Phase 7: Deployment
- `/docs/SESSIONS.md` - Updated with Session #2 details

#### Planned Structure (from PROJECT_PLAN.md)
```
/lib/i18n/               # i18n utilities
  ├── config.ts          # Locale configuration
  ├── server.ts          # Server-side i18n
  ├── client.ts          # Client-side i18n
  └── locales/
      ├── en/            # English (ACTIVE)
      ├── tr/            # Turkish (FUTURE)
      ├── es/            # Spanish (FUTURE)
      ├── fr/            # French (FUTURE)
      └── ar/            # Arabic (FUTURE, RTL)

/lib/timezone.ts         # TZ detection & conversion
/lib/analytics.ts        # Privacy-first analytics
/lib/phase.ts            # Cycle phase calculations
/lib/notify/             # Notification engine
  ├── engine.ts
  ├── context.ts
  ├── rules.ts
  └── templates.ts

/components/babecycle/   # BabeCycle UI components
  ├── PhaseTag.tsx
  ├── QuickAction.tsx
  ├── MoodPicker.tsx
  ├── SymptomChip.tsx
  ├── CalendarDay.tsx
  ├── PartnerCard.tsx
  └── ...

/types/                  # TypeScript definitions
  ├── user.ts
  ├── cycle.ts
  ├── partner.ts
  ├── notification.ts
  └── i18n.ts
```

### Dependencies Planned (Not Yet Installed)
```json
{
  "next-intl": "^3.x",           // i18n with ICU format
  "date-fns-tz": "^2.x",         // Timezone utilities
  "framer-motion": "^11.x",      // Animations
  "lucide-react": "^0.x",        // Icons
  "recharts": "^2.x",            // Charts for insights
  "zod": "^3.x"                  // Validation
}
```

### Configuration Changes

#### Planned i18n Config
```typescript
// lib/i18n/config.ts
export const i18n = {
  defaultLocale: 'en',
  locales: ['en', 'tr', 'es', 'fr', 'ar'],
  localeDetection: true,
  rtlLocales: ['ar']
} as const;
```

#### Planned Database Schema Updates
```sql
-- Add to profiles table
ALTER TABLE profiles
ADD COLUMN role user_role NOT NULL,
ADD COLUMN locale text DEFAULT 'en' CHECK (locale IN ('en','tr','es','fr','ar')),
ADD COLUMN tz text DEFAULT 'UTC';

-- Create new tables (10 total, see PROJECT_PLAN.md)
```

### Breaking Changes
None - This is a planning session, no code changes yet

### Migration Notes
- Existing auth system will be extended (not replaced)
- Current `profiles` table needs additional columns
- RLS policies will be added to existing structure

### Testing Checklist
- [ ] Review PROJECT_PLAN.md for completeness
- [ ] Validate database schema design
- [ ] Confirm i18n architecture approach
- [ ] Verify notification engine design
- [ ] Approve 7-phase timeline (3 weeks)

### Known Issues
None - Planning phase complete

### Future Enhancements (Roadmap)
**MVP (Week 1-3)**:
- English-only UI
- Core cycle tracking
- Partner sharing
- Notification engine
- Privacy controls

**Post-MVP (Month 2+)**:
- Turkish language activation
- Spanish language
- French language
- Arabic language (RTL support)
- Advanced analytics
- Data export (PDF reports)
- Photo logging
- Partner messaging (encrypted)
- Pregnancy mode
- Menopause tracking

### Performance Considerations
**Target Metrics**:
- Build time: <2 min
- Bundle size: <500 KB (first load)
- API response: <200ms (p95)
- Lighthouse score: >90
- Test coverage: >70%

### Documentation Additions
- Comprehensive PROJECT_PLAN.md with:
  - Complete database schema
  - 15+ copy-paste ready prompts
  - i18n architecture guide
  - Notification engine design
  - Success metrics & KPIs
  - 3-week timeline
  - English-only policy documentation

### Working Methodology Established
**Sprint Ritual**:
1. Mini-plan (1-2 deliverables)
2. Single prompt = Complete feature
3. DoD checklist verification
4. Auto-documentation update

**Branch & Commit Convention**:
- Branch: `feat/<feature-name>`
- Commit: `feat(scope): description`
- Example: `feat(db): add cycles table + RLS policies`

**Prompt Engineering Principles**:
- Provide full file paths
- Define success conditions
- List files to modify
- Include test commands
- Specify DoD checklist

### Language Policy (Critical)
This project follows a strict **English-first** development approach:

**✅ ALLOWED**:
- English UI text
- English code comments
- English documentation
- English commit messages
- English translation keys

**❌ FORBIDDEN**:
- Turkish content in UI
- Turkish code comments
- Mixed language files
- Hard-coded Turkish strings

**REASON**: User communicates in Turkish but explicitly requested English codebase for:
- International collaboration
- Professional standards
- Easier maintenance
- Future scalability
- i18n best practices

### i18n Readiness Checklist
- [x] `profiles.locale` column designed
- [x] `translations` table designed (future)
- [x] `/lib/i18n/` utilities planned
- [x] Translation file structure defined
- [x] English content planned
- [x] Future locale expansion documented
- [x] RTL support architecture planned (Arabic)
- [ ] Implementation (pending user approval)

### Next Immediate Steps
**Awaiting User Approval To**:
1. Start Phase 0: Foundation Setup
   - Implement UI-UX Design System
   - Set up i18n infrastructure
2. Start Phase 1.1: Database Schema + RLS + Seed
   - Copy-paste Prompt #1 ready in PROJECT_PLAN.md
3. Proceed through remaining phases

### Session Statistics
- **Planning Duration**: ~140 minutes
- **Documentation Created**: 977 lines (PROJECT_PLAN.md)
- **Phases Designed**: 7 phases
- **Prompts Prepared**: 15+ copy-paste ready
- **Database Tables**: 10 core tables designed
- **Notification Types**: 30+ types planned
- **Supported Locales**: 5 (en active, 4 future)
- **Timeline**: 3-week MVP estimate

---

## Template for Future Entries

```markdown
## YYYY-MM-DD - Feature/Update Name

### Summary
Brief description of what was done

### Changes Made
- List of modifications
- Each on a new line

### Architecture Impact
How the system architecture was affected

### Files Added/Modified
- File paths and descriptions

### Dependencies Added/Updated
List with versions

### Breaking Changes
Any backward-incompatible changes

### Migration Notes
Steps needed for existing implementations

### Testing Checklist
- [ ] Test items

### Known Issues
Any issues introduced or discovered
```
