# System Architecture

## Overview

This project follows a modern, serverless architecture using Next.js 15 App Router with Supabase as the backend-as-a-service platform.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Client Side                          │
├─────────────────────────────────────────────────────────────┤
│  Next.js App Router (React 19)                              │
│  ├── Public Routes                                           │
│  │   ├── / (Home page)                                      │
│  │   ├── /login                                             │
│  │   └── /signup                                            │
│  │                                                           │
│  └── Protected Routes (via Middleware)                       │
│      └── /dashboard                                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                       Middleware Layer                       │
├─────────────────────────────────────────────────────────────┤
│  middleware.ts                                               │
│  ├── Route Protection                                        │
│  ├── Auth State Validation                                   │
│  └── Redirects (login ↔ dashboard)                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Supabase Client Layer                     │
├─────────────────────────────────────────────────────────────┤
│  lib/supabase/                                               │
│  ├── client.ts (Browser - @supabase/ssr)                    │
│  ├── server.ts (Server Components - @supabase/ssr)          │
│  └── middleware.ts (Middleware - @supabase/ssr)             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Supabase Backend                        │
├─────────────────────────────────────────────────────────────┤
│  Authentication Service                                      │
│  ├── Email/Password Auth                                     │
│  ├── Email Verification                                      │
│  └── Session Management                                      │
│                                                              │
│  Database (PostgreSQL)                                       │
│  └── Auth tables (managed by Supabase)                      │
└─────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Client Components (`use client`)
- **Login/Signup Pages**: Handle user input and auth state
- **LogoutButton**: Manages sign-out flow
- Uses `lib/supabase/client.ts` for browser-side operations

### Server Components (default)
- **Dashboard**: Protected page with server-side auth check
- **Home Page**: Public landing page
- Uses `lib/supabase/server.ts` for server-side operations

### Middleware
- **Route Protection**: Validates auth on every request
- **Auto-redirects**:
  - Unauthenticated → `/login`
  - Authenticated trying to access auth pages → `/dashboard`
- Uses `lib/supabase/middleware.ts`

## Authentication Flow

### Sign Up Flow
```
User enters email/password
    ↓
Client calls supabase.auth.signUp()
    ↓
Supabase creates account
    ↓
Sends verification email
    ↓
User clicks link → /auth/callback
    ↓
Session established → Redirect to /dashboard
```

### Sign In Flow
```
User enters credentials
    ↓
Client calls supabase.auth.signInWithPassword()
    ↓
Supabase validates credentials
    ↓
Returns session tokens
    ↓
Cookies set via SSR helpers
    ↓
Redirect to /dashboard
```

### Protected Route Access
```
Request to /dashboard
    ↓
Middleware intercepts
    ↓
Checks session via supabase.auth.getUser()
    ↓
Valid? → Allow access
Invalid? → Redirect to /login
```

## Data Flow

### Client → Server
1. User actions trigger client components
2. Client uses `@supabase/ssr` browser client
3. Auth state stored in cookies (httpOnly, secure)
4. Server Components read cookies via `@supabase/ssr` server client

### Server → Client
1. Server Components fetch data server-side
2. Pre-rendered HTML sent to client
3. Hydration occurs with React
4. Client-side navigation via Next.js App Router

## Security Architecture

### Authentication
- **Session Management**: HTTP-only cookies via Supabase SSR
- **Token Refresh**: Automatic via middleware
- **CSRF Protection**: Built into Supabase client

### Route Protection
- **Middleware**: Validates auth on every request
- **Server Components**: Double-check auth server-side
- **Client Components**: Rely on middleware + server validation

### Environment Variables
- `NEXT_PUBLIC_SUPABASE_URL`: Public, safe for client
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Public, safe (RLS enforced)
- No service role key exposed

## Tech Stack Details

### Frontend
- **Next.js 15**: Latest App Router with Turbopack
- **React 19**: Latest stable
- **TypeScript 5**: Full type safety
- **Tailwind CSS 4**: Utility-first styling

### Backend
- **Supabase**:
  - PostgreSQL database
  - Auth service
  - Realtime subscriptions (future)
  - Storage (future)

### Deployment
- **Vercel**: Optimized for Next.js
- **Edge Functions**: Middleware runs on edge
- **ISR/SSR**: Server-side rendering capability

## File Structure Rationale

```
app/
├── (auth)/              # Route group - shares layout, no URL segment
│   ├── login/
│   └── signup/
├── auth/
│   └── callback/        # Email verification endpoint
└── dashboard/           # Protected area

lib/
└── supabase/            # Supabase clients separated by context
    ├── client.ts        # Browser context
    ├── server.ts        # Server Component context
    └── middleware.ts    # Middleware context

components/              # Shared UI components
└── LogoutButton.tsx

middleware.ts            # Root-level route protection
```

## Design Decisions

### Why @supabase/ssr?
- Proper cookie handling for Next.js App Router
- Separate clients for different execution contexts
- Automatic session refresh

### Why Route Groups?
- Clean URL structure (`/login` not `/auth/login`)
- Shared layout for auth pages
- Better organization

### Why Middleware for Auth?
- Runs on every request (edge)
- Fast auth checks before page render
- Centralized protection logic

### Why Server Components Default?
- Better performance (less JS shipped)
- SEO friendly
- Secure data fetching

## Scalability Considerations

### Current State
- Stateless authentication via JWT
- Edge-optimized middleware
- Server-side rendering ready

### Future Enhancements
- Add database tables via Supabase
- Implement Drizzle ORM for type-safe queries
- Add API routes for complex operations
- Implement Supabase Realtime for live updates
- Add Redis for caching (if needed)
- Implement rate limiting

## Performance Optimization

- **Static Generation**: Home page pre-rendered
- **Server Components**: Dashboard rendered server-side
- **Turbopack**: Fast development builds
- **Edge Middleware**: Auth checks on CDN edge
- **Code Splitting**: Automatic per-route

## Monitoring & Observability

### Current
- Next.js built-in analytics (opt-in)
- Vercel deployment logs

### Recommended Additions
- Sentry for error tracking
- Vercel Analytics for performance
- Supabase dashboard for auth metrics
