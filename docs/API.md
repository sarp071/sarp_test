# API Documentation

## Overview

This document describes the API endpoints and authentication flows used in the application.

## Authentication Endpoints

### Email Verification Callback

**Endpoint**: `GET /auth/callback`

**Purpose**: Handles email verification after user signup

**Query Parameters**:
- `code` (string, required): Verification code from Supabase email
- `next` (string, optional): Redirect path after verification (default: `/dashboard`)

**Response**:
- **Success**: Redirects to dashboard or specified `next` path
- **Error**: Redirects to `/auth/auth-code-error`

**Implementation**: [/app/auth/callback/route.ts](../app/auth/callback/route.ts)

**Flow**:
```
1. User clicks verification link in email
2. Supabase redirects to /auth/callback?code=XXX
3. Route handler exchanges code for session
4. Sets auth cookies
5. Redirects to dashboard
```

**Example**:
```
https://yourapp.com/auth/callback?code=abc123&next=/dashboard
```

## Supabase Client Methods

### Authentication Methods

#### Sign Up
```typescript
const { error } = await supabase.auth.signUp({
  email: string,
  password: string,
  options: {
    emailRedirectTo: string
  }
})
```

**Usage**: User registration
**Location**: [/app/(auth)/signup/page.tsx](../app/(auth)/signup/page.tsx)

#### Sign In
```typescript
const { error } = await supabase.auth.signInWithPassword({
  email: string,
  password: string
})
```

**Usage**: User login
**Location**: [/app/(auth)/login/page.tsx](../app/(auth)/login/page.tsx)

#### Sign Out
```typescript
await supabase.auth.signOut()
```

**Usage**: User logout
**Location**: [/components/LogoutButton.tsx](../components/LogoutButton.tsx)

#### Get User
```typescript
const { data: { user } } = await supabase.auth.getUser()
```

**Usage**: Retrieve current authenticated user
**Locations**:
- Middleware validation
- Protected page checks
- Dashboard user info display

#### Exchange Code for Session
```typescript
const { error } = await supabase.auth.exchangeCodeForSession(code)
```

**Usage**: Email verification
**Location**: [/app/auth/callback/route.ts](../app/auth/callback/route.ts)

## Client Types

### Browser Client
**File**: [/lib/supabase/client.ts](../lib/supabase/client.ts)
**Usage**: Client Components, browser-side operations
**Methods**: All auth methods

### Server Client
**File**: [/lib/supabase/server.ts](../lib/supabase/server.ts)
**Usage**: Server Components, API routes
**Methods**: Read operations, getUser()

### Middleware Client
**File**: [/lib/supabase/middleware.ts](../lib/supabase/middleware.ts)
**Usage**: Route protection, session refresh
**Methods**: getUser(), session management

## Error Handling

### Common Errors

#### Invalid Credentials
```typescript
{
  error: {
    message: "Invalid login credentials"
  }
}
```

#### Email Not Confirmed
```typescript
{
  error: {
    message: "Email not confirmed"
  }
}
```

#### Session Expired
- Middleware automatically refreshes
- Redirects to login if refresh fails

## Session Management

### Cookie Configuration
```typescript
{
  cookies: {
    getAll(): Returns all cookies
    setAll(cookies): Sets multiple cookies
  }
}
```

**Properties**:
- `httpOnly`: true (security)
- `secure`: true (HTTPS only)
- `sameSite`: 'lax'
- `path`: '/'

### Session Lifecycle
```
1. User signs in
2. Supabase returns access token + refresh token
3. Tokens stored in httpOnly cookies
4. Middleware validates on each request
5. Auto-refresh when expired
6. Sign out clears all cookies
```

## Future API Endpoints

### Planned Additions

#### User Profile
```typescript
// GET /api/profile
// Returns user profile data

// PUT /api/profile
// Updates user profile
```

#### Password Reset
```typescript
// POST /api/auth/reset-password
// Initiates password reset flow

// POST /api/auth/update-password
// Updates password with reset token
```

#### OAuth Providers
```typescript
// GET /api/auth/google
// Initiates Google OAuth flow

// GET /api/auth/github
// Initiates GitHub OAuth flow
```

## Rate Limiting

### Current Status
- No rate limiting implemented
- Relies on Supabase default limits

### Recommended Implementation
```typescript
// Future: Add rate limiting middleware
// 5 requests per minute for auth endpoints
// 100 requests per minute for API calls
```

## Security Headers

### Recommended Headers
```typescript
{
  'X-Frame-Options': 'DENY',
  'X-Content-Type-Options': 'nosniff',
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'geolocation=(), microphone=(), camera=()'
}
```

## CORS Configuration

### Current Status
- Same-origin only
- Vercel handles CORS automatically

### Future Multi-Domain Setup
```typescript
// Configure CORS for API routes
const allowedOrigins = [
  'https://app.yourdomain.com',
  'https://admin.yourdomain.com'
]
```

## Monitoring & Logging

### Recommended Tools
- **Sentry**: Error tracking
- **Vercel Analytics**: Performance metrics
- **Supabase Dashboard**: Auth analytics

### Key Metrics to Track
- Auth success/failure rate
- Average session duration
- API response times
- Error rates by endpoint

## Testing

### Example Test Cases

#### Sign Up Flow
```typescript
test('should create new user account', async () => {
  const { error } = await supabase.auth.signUp({
    email: 'test@example.com',
    password: 'securepassword123'
  })
  expect(error).toBeNull()
})
```

#### Protected Route
```typescript
test('should redirect unauthenticated user', async () => {
  const response = await fetch('/dashboard')
  expect(response.redirected).toBe(true)
  expect(response.url).toContain('/login')
})
```

## Environment Variables

### Required
```env
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### Optional (Future)
```env
SUPABASE_SERVICE_ROLE_KEY=your-service-key  # Admin operations
SUPABASE_JWT_SECRET=your-jwt-secret         # Token verification
```

## Webhook Integration (Future)

### Supabase Webhooks
```typescript
// POST /api/webhooks/supabase
// Handle auth events: user.created, user.deleted, etc.
```

## API Versioning

### Current Version
- v1 (implicit, no version prefix)

### Future Versioning Strategy
- Use `/api/v1/`, `/api/v2/` prefixes
- Maintain backward compatibility
- Deprecation notices 3 months in advance
