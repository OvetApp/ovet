# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Development:**

```bash
pnpm dev          # Start all development servers
pnpm build        # Build all apps and packages
pnpm lint         # Run ESLint across workspaces
pnpm format       # Format code with Prettier
```

**Web App Specific:**

```bash
cd apps/web
pnpm dev          # Next.js dev with Turbopack
pnpm typecheck    # TypeScript validation
pnpm lint:fix     # Auto-fix ESLint issues
```

**Testing:**

```bash
pnpm test         # Run all unit tests
pnpm test:coverage # Run tests with coverage
pnpm test:ui      # Run tests with UI
pnpm test:e2e     # Run E2E tests with Playwright
```

## Architecture Overview

This is a **Turborepo monorepo** with pnpm workspaces containing:

- **apps/web** - Next.js 15 app with App Router, Supabase auth, and shadcn/ui
- **packages/ui** - Shared component library built on shadcn/ui and Radix primitives
- **packages/eslint-config** - Shared linting rules
- **packages/typescript-config** - Shared TypeScript configurations

## Key Technologies

- **Next.js 15** with App Router and Turbopack
- **React 19** with modern patterns
- **TypeScript** throughout
- **Tailwind CSS v4** for styling
- **Supabase** for auth and backend
- **shadcn/ui** components on Radix UI

## Authentication Architecture

The app uses **Supabase Auth** with SSR support:

- `middleware.ts` - Route protection and user validation
- `lib/supabase/client.ts` - Client-side Supabase instance
- `lib/supabase/server.ts` - Server-side Supabase with cookies
- `/app/auth/*` - Authentication pages (login, signup, reset)
- `/app/protected/*` - Routes requiring authentication

Authentication flow: middleware checks user → redirects unauthenticated users → protected routes validate server-side.

## Component Patterns

**UI Package Structure:**

- Export components from `packages/ui/src/components/`
- Use compound component pattern with shadcn/ui
- Import via `@workspace/ui/components/[component]`
- Shared utilities in `packages/ui/src/lib/utils.ts`

**Path Aliases:**

- `@/*` - App-level imports (apps/web)
- `@workspace/ui/*` - UI package imports
- Configured in `tsconfig.json` and `next.config.mjs`

## Monorepo Conventions

- Use `workspace:*` for internal dependencies
- All packages follow `@workspace/[name]` naming
- Shared configs in dedicated packages
- Turborepo handles build optimization and caching

## Code Style Guidelines

**Naming Conventions:**

- Components: PascalCase with descriptive names (e.g., `LoginForm`, `SignUpForm`)
- Files: kebab-case for components (e.g., `login-form.tsx`, `sign-up-form.tsx`)
- Functions: camelCase with descriptive verbs (e.g., `handleLogin`, `createClient`)
- Types/Interfaces: PascalCase (follows TypeScript conventions)

**Component Patterns:**

- Use `'use client'` directive for client components at top of file
- Destructure props with `React.ComponentPropsWithoutRef<'element'>`
- Handle loading states with boolean flags (`isLoading`)
- Use consistent error handling with try/catch blocks
- Prefer controlled components with React state

**Import Organization:**

1. React and Next.js imports first
2. Third-party libraries
3. Workspace packages (`@workspace/ui/...`)
4. Local imports (`@/...`)
5. Relative imports (`./`, `../`)

**ESLint Configuration:**

- Uses `@workspace/eslint-config` with TypeScript, Prettier, and Turbo rules
- Only warnings enabled (no build-breaking errors)
- Turbo environment variable validation
- Auto-formatting with Prettier

## Environment Setup

**Prerequisites:**

- Node.js ≥20
- pnpm 10.4.1 (specified in packageManager)
- Git for version control

**First-time Setup:**

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp apps/web/.env.example apps/web/.env  # if exists
# Edit .env with your Supabase credentials
```

**Supabase Configuration:**
Required environment variables in `apps/web/.env`:

```bash
NEXT_PUBLIC_SUPABASE_URL="your-supabase-url"
NEXT_PUBLIC_SUPABASE_ANON_KEY="your-supabase-anon-key"
```

**Development Commands:**

```bash
pnpm dev          # Starts all dev servers with Turbo
pnpm build        # Builds all packages and apps
pnpm lint         # Runs ESLint with auto-fix
pnpm format       # Formats code with Prettier
```

## Workflow Optimization

**Claude Code Integration:**

- Use `@claude` in GitHub issues and PR comments to trigger automation
- Claude has access to full codebase context via CLAUDE.md
- Workflow configured for issue resolution and code review

**Custom Slash Commands:** (Suggested)

```bash
/setup     # Run full environment setup
/test-all  # Run complete test suite
/type-check # TypeScript validation across workspaces
/deploy    # Build and deploy pipeline
```

**Tool Permissions:** (Recommended)

- `Bash(pnpm install)` - Dependency management
- `Bash(pnpm run build)` - Build process
- `Bash(pnpm run test*)` - All test commands
- `Bash(pnpm run lint*)` - Linting and formatting

## Development Workflow

**Issue Resolution:**

- When solving GitHub issues, always create a pull request
- Include issue number in PR title and description
- Use conventional commit messages with issue references
- Run `pnpm lint` and `pnpm typecheck` before committing
- Ensure all tests pass with `pnpm test`
