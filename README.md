# Next.js + Supabase Authentication Starter

A modern, production-ready starter template built with Next.js 15, TypeScript, Tailwind CSS, and Supabase authentication.

## Features

- **Next.js 15** with App Router
- **TypeScript** for type safety
- **Tailwind CSS** for styling
- **Supabase** authentication (email/password)
- **Protected routes** with middleware
- **Server and client components** properly separated
- **Vercel** deployment ready

## Tech Stack

- [Next.js 15](https://nextjs.org/) - React framework
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [Tailwind CSS](https://tailwindcss.com/) - Styling
- [Supabase](https://supabase.com/) - Authentication & Database
- [Vercel](https://vercel.com/) - Deployment platform

## Getting Started

### 1. Clone and Install

```bash
git clone <your-repo-url>
cd sarpproject
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://app.supabase.com)
2. Go to Project Settings > API
3. Copy your project URL and anon key
4. Create a `.env.local` file:

```bash
cp .env.local.example .env.local
```

5. Fill in your Supabase credentials in `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

### 3. Configure Supabase Authentication

1. In your Supabase dashboard, go to Authentication > URL Configuration
2. Add your site URL (e.g., `http://localhost:3000` for development)
3. Add redirect URLs:
   - `http://localhost:3000/auth/callback` (development)
   - `https://your-domain.com/auth/callback` (production)

### 4. Run the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see your app.

## Project Structure

```
├── app/
│   ├── (auth)/
│   │   ├── login/          # Login page
│   │   └── signup/         # Signup page
│   ├── auth/
│   │   └── callback/       # Auth callback handler
│   ├── dashboard/          # Protected dashboard page
│   └── page.tsx            # Home page
├── components/
│   └── LogoutButton.tsx    # Logout component
├── lib/
│   └── supabase/
│       ├── client.ts       # Client-side Supabase helper
│       ├── server.ts       # Server-side Supabase helper
│       └── middleware.ts   # Middleware Supabase helper
└── middleware.ts           # Route protection middleware
```

## Features Explained

### Authentication Flow

1. **Sign Up**: Users create an account at `/signup`
2. **Email Confirmation**: Supabase sends a confirmation email
3. **Sign In**: Users log in at `/login`
4. **Protected Routes**: Dashboard is protected by middleware
5. **Sign Out**: Users can log out from the dashboard

### Route Protection

The `middleware.ts` file protects routes:
- Redirects unauthenticated users to `/login`
- Redirects authenticated users away from auth pages to `/dashboard`

## Deployment

### Deploy to Vercel

1. Push your code to GitHub
2. Import your repository to [Vercel](https://vercel.com)
3. Add environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4. Deploy!

### Update Supabase Redirect URLs

After deployment, add your production URL to Supabase:
1. Go to Authentication > URL Configuration
2. Add `https://your-domain.vercel.app/auth/callback`

## Next Steps

Here are some features you might want to add:

- **Database Schema**: Create tables and relationships in Supabase
- **Profile Management**: Add user profile pages
- **Password Reset**: Implement forgot password flow
- **OAuth Providers**: Add Google, GitHub, etc.
- **Database ORM**: Add [Drizzle ORM](https://orm.drizzle.team/)
- **Form Validation**: Add [Zod](https://zod.dev/) for schema validation
- **UI Components**: Add [shadcn/ui](https://ui.shadcn.com/)
- **API Routes**: Create API endpoints for your app
- **Real-time Features**: Use Supabase Realtime

## Learn More

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)

## Support

For issues and questions:
- [Next.js GitHub](https://github.com/vercel/next.js)
- [Supabase Discord](https://discord.supabase.com)

## Documentation Guidelines for AI Assistants

### Critical Rule: Automatic Documentation Updates

**IMPORTANT**: When working with AI assistants (Claude, etc.) on this project, the following rule MUST be followed:

#### Auto-Documentation Protocol

AI assistants must automatically create and update documentation files at the end of each session, especially when making:
- System architecture changes
- Critical feature implementations
- Database schema modifications
- API endpoint additions/changes
- Authentication flow updates
- Middleware or routing changes

#### Documentation Structure

The project uses the following documentation structure:

```
/docs
├── ARCHITECTURE.md      # System architecture overview
├── CHANGES.md          # Changelog for major updates
├── API.md              # API endpoints documentation
├── DATABASE.md         # Database schema and relationships
└── SESSIONS.md         # Session-by-session development log
```

#### Session-End Documentation Checklist

At the end of each session, AI assistants should:

1. **Review Changes**: Analyze all modifications made during the session
2. **Identify Critical Updates**: Determine if changes affect:
   - System architecture
   - Authentication/authorization
   - Database structure
   - API contracts
   - Security implementations
3. **Update Relevant Docs**: Without waiting for user command:
   - Update `ARCHITECTURE.md` if system design changed
   - Add entry to `CHANGES.md` with date and summary
   - Update `API.md` if endpoints were added/modified
   - Update `DATABASE.md` if schema changed
   - Log session summary in `SESSIONS.md`
4. **Create New Docs**: If needed, create specific documentation files for new major features

#### Documentation Format

Each documentation update should include:
- **Date**: ISO format (YYYY-MM-DD)
- **Session Summary**: Brief overview of what was done
- **Changes Made**: Bullet-point list of modifications
- **Impact**: How changes affect the system
- **Breaking Changes**: Any backward-incompatible updates
- **Migration Notes**: Steps needed for existing implementations

#### Example Entry in CHANGES.md

```markdown
## 2025-11-08 - Initial Setup

### Summary
Initial project setup with Next.js 15, TypeScript, Tailwind CSS, and Supabase authentication.

### Changes Made
- Created Next.js 15 project with App Router
- Implemented Supabase authentication (email/password)
- Set up protected routes with middleware
- Created login, signup, and dashboard pages
- Configured Vercel deployment

### Architecture
- Client/Server Supabase helpers separation
- Route protection via Next.js middleware
- Server-side auth validation for protected pages

### Files Added
- /app/(auth)/login/page.tsx
- /app/(auth)/signup/page.tsx
- /app/dashboard/page.tsx
- /lib/supabase/client.ts
- /lib/supabase/server.ts
- /lib/supabase/middleware.ts
- /middleware.ts
```

#### Why This Matters

This automatic documentation approach ensures:
- **Knowledge Continuity**: Future sessions can understand past decisions
- **Architecture Clarity**: System design is always up-to-date
- **Onboarding Speed**: New developers can quickly understand the project
- **Change Tracking**: History of modifications is preserved
- **Decision Context**: Why changes were made is documented

**Note to AI Assistants**: This is a mandatory protocol. Always update documentation at session end, even if the user doesn't explicitly ask for it.

## License

MIT
