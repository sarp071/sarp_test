# Database Documentation

## Overview

This project uses **Supabase** (PostgreSQL) as its database backend. Currently, only authentication tables are in use, managed automatically by Supabase.

## Current Schema

### Auth Tables (Managed by Supabase)

Supabase automatically manages these tables in the `auth` schema:

#### auth.users
Primary user table managed by Supabase Auth.

```sql
Table: auth.users
├── id                  uuid (PK)
├── email               text (unique)
├── encrypted_password  text
├── email_confirmed_at  timestamp
├── invited_at          timestamp
├── confirmation_token  text
├── confirmation_sent_at timestamp
├── recovery_token      text
├── recovery_sent_at    timestamp
├── email_change_token_new text
├── email_change        text
├── email_change_sent_at timestamp
├── last_sign_in_at     timestamp
├── raw_app_meta_data   jsonb
├── raw_user_meta_data  jsonb
├── is_super_admin      boolean
├── created_at          timestamp
├── updated_at          timestamp
├── phone               text
├── phone_confirmed_at  timestamp
├── phone_change        text
├── phone_change_token  text
├── phone_change_sent_at timestamp
├── confirmed_at        timestamp (computed)
├── email_change_token_current text
├── email_change_confirm_status smallint
├── banned_until        timestamp
├── reauthentication_token text
├── reauthentication_sent_at timestamp
└── is_sso_user         boolean
```

**Key Fields**:
- `id`: Unique user identifier (UUID)
- `email`: User's email address
- `email_confirmed_at`: Timestamp of email verification
- `last_sign_in_at`: Last login timestamp
- `raw_user_meta_data`: Custom user metadata (JSON)
- `raw_app_meta_data`: Application metadata (JSON)

#### auth.sessions
Active user sessions.

```sql
Table: auth.sessions
├── id            uuid (PK)
├── user_id       uuid (FK -> auth.users.id)
├── created_at    timestamp
├── updated_at    timestamp
├── factor_id     uuid
├── aal           text
├── not_after     timestamp
└── refreshed_at  timestamp
```

#### auth.refresh_tokens
Refresh tokens for session management.

```sql
Table: auth.refresh_tokens
├── id           bigint (PK)
├── token        text (unique)
├── user_id      uuid (FK -> auth.users.id)
├── revoked      boolean
├── created_at   timestamp
├── updated_at   timestamp
├── parent       text
└── session_id   uuid (FK -> auth.sessions.id)
```

## Future Schema Plans

### Profiles Table
Extended user profile information.

```sql
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE,
  full_name text,
  avatar_url text,
  bio text,
  website text,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view all profiles
CREATE POLICY "Public profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- Policy: Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);
```

### Posts Table (Example)
If building a blog or social feature.

```sql
CREATE TABLE public.posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  title text NOT NULL,
  content text,
  published boolean DEFAULT false,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

-- Anyone can view published posts
CREATE POLICY "Published posts are public"
  ON public.posts FOR SELECT
  USING (published = true);

-- Users can view their own unpublished posts
CREATE POLICY "Users can view own posts"
  ON public.posts FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create posts
CREATE POLICY "Users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own posts
CREATE POLICY "Users can update own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);
```

## Row Level Security (RLS)

### What is RLS?
Row Level Security ensures users can only access data they're authorized to see, enforced at the database level.

### Current RLS Setup
- Auth tables: Managed by Supabase, automatically secured
- Public tables: None yet

### RLS Best Practices
1. **Enable RLS on all public tables**
2. **Default deny**: No policy = no access
3. **Use `auth.uid()`**: Get current user's ID
4. **Test policies**: Verify access controls work
5. **Separate read/write policies**: Fine-grained control

### Example Policies

#### Read Own Data
```sql
CREATE POLICY "Users can read own data"
  ON table_name FOR SELECT
  USING (auth.uid() = user_id);
```

#### Public Read, Own Write
```sql
-- Anyone can read
CREATE POLICY "Public read"
  ON table_name FOR SELECT
  USING (true);

-- Only owner can update
CREATE POLICY "Own update"
  ON table_name FOR UPDATE
  USING (auth.uid() = user_id);
```

#### Admin Access
```sql
CREATE POLICY "Admins have full access"
  ON table_name FOR ALL
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users WHERE raw_app_meta_data->>'role' = 'admin'
    )
  );
```

## Database Migrations

### Current Status
- No custom migrations yet
- Using Supabase managed auth tables

### Migration Strategy (Future)

#### Using Supabase CLI
```bash
# Create new migration
supabase migration new create_profiles_table

# Apply migrations
supabase db push

# Reset database (dev only)
supabase db reset
```

#### Using Drizzle ORM
```bash
# Generate migration
npm run db:generate

# Apply migration
npm run db:migrate

# Drop migration
npm run db:drop
```

## Indexes

### Recommended Indexes (Future)

```sql
-- Profile lookups by username
CREATE INDEX profiles_username_idx ON public.profiles(username);

-- Posts by user
CREATE INDEX posts_user_id_idx ON public.posts(user_id);

-- Published posts with created_at for sorting
CREATE INDEX posts_published_created_idx
  ON public.posts(published, created_at DESC);

-- Full-text search on posts
CREATE INDEX posts_content_search_idx
  ON public.posts USING gin(to_tsvector('english', content));
```

## Database Functions

### Example: Update Updated_At Timestamp

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Example: Automatic Profile Creation

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, full_name)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'username',
    NEW.raw_user_meta_data->>'full_name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger on user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## Data Types

### Common PostgreSQL Types Used

```sql
uuid          -- Unique identifiers
text          -- Strings (unlimited length)
varchar(n)    -- Strings (limited length)
integer       -- Whole numbers
bigint        -- Large whole numbers
boolean       -- true/false
timestamp     -- Date and time
timestamptz   -- Timestamp with timezone
jsonb         -- JSON data (binary, indexed)
json          -- JSON data (text)
```

### Custom Types (Future)

```sql
-- Enum for post status
CREATE TYPE post_status AS ENUM ('draft', 'published', 'archived');

-- Use in table
CREATE TABLE posts (
  id uuid PRIMARY KEY,
  status post_status DEFAULT 'draft'
);
```

## Backup Strategy

### Automatic Backups (Supabase)
- Daily automatic backups
- Point-in-time recovery
- 7-day retention (Pro plan)

### Manual Backups
```bash
# Using Supabase CLI
supabase db dump -f backup.sql

# Restore
psql -h db.xxx.supabase.co -U postgres -d postgres -f backup.sql
```

## Performance Optimization

### Query Optimization Tips
1. Use indexes on frequently queried columns
2. Limit result sets with pagination
3. Use `SELECT` specific columns, not `*`
4. Analyze slow queries with `EXPLAIN`
5. Use materialized views for complex queries

### Connection Pooling
- Supabase provides built-in pooling
- Use connection string with pooler for serverless

## Real-time Subscriptions

### Setup (Future)

```typescript
// Subscribe to changes
const channel = supabase
  .channel('posts-changes')
  .on(
    'postgres_changes',
    {
      event: '*',
      schema: 'public',
      table: 'posts'
    },
    (payload) => {
      console.log('Change received!', payload)
    }
  )
  .subscribe()
```

### Enable Realtime on Table
```sql
-- Enable realtime for table
ALTER PUBLICATION supabase_realtime ADD TABLE public.posts;
```

## Database Access Methods

### From Server Components
```typescript
import { createClient } from '@/lib/supabase/server'

const supabase = await createClient()
const { data, error } = await supabase
  .from('profiles')
  .select('*')
  .eq('id', userId)
```

### From Client Components
```typescript
import { createClient } from '@/lib/supabase/client'

const supabase = createClient()
const { data, error } = await supabase
  .from('profiles')
  .select('*')
  .eq('id', userId)
```

### From API Routes
```typescript
import { createClient } from '@/lib/supabase/server'

export async function GET(request: Request) {
  const supabase = await createClient()
  const { data } = await supabase.from('profiles').select('*')
  return Response.json(data)
}
```

## Type Safety with TypeScript

### Generate Types (Future)

```bash
# Generate types from database schema
supabase gen types typescript --local > lib/database.types.ts
```

### Usage
```typescript
import { Database } from '@/lib/database.types'

type Profile = Database['public']['Tables']['profiles']['Row']
type ProfileInsert = Database['public']['Tables']['profiles']['Insert']
type ProfileUpdate = Database['public']['Tables']['profiles']['Update']
```

## Testing

### Test Database Setup
```bash
# Use separate Supabase project for testing
# Or use local Supabase instance
supabase start
```

### Seed Data
```sql
-- seeds/seed.sql
INSERT INTO public.profiles (id, username, full_name)
VALUES
  ('uuid-1', 'testuser1', 'Test User 1'),
  ('uuid-2', 'testuser2', 'Test User 2');
```

## Monitoring

### Recommended Metrics
- Query performance
- Connection pool usage
- Table size growth
- Index usage
- Slow queries

### Tools
- Supabase Dashboard
- PostgreSQL logs
- Custom monitoring queries

## Security Checklist

- [x] Row Level Security enabled on auth tables (by Supabase)
- [ ] RLS policies created for public tables
- [ ] Service role key secured (not in client)
- [ ] Input validation on all user data
- [ ] SQL injection prevention (use parameterized queries)
- [ ] Regular backups configured
- [ ] Audit logs reviewed
- [ ] Access controls tested

## Resources

- [Supabase Database Docs](https://supabase.com/docs/guides/database)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
