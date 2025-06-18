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

## Development Workflow

**Issue Resolution:**
- When solving GitHub issues, always create a pull request
- Include issue number in PR title and description
- Use conventional commit messages with issue references