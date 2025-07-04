

# Ovet - Turborepo Monorepo with Next.js 15 & Supabase

[![Next.js](https://img.shields.io/badge/Next.js-15-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19-61DAFB?style=flat-square&logo=react)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-3178C6?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Auth%20%26%20DB-3ECF8E?style=flat-square&logo=supabase)](https://supabase.com/)
[![Supabase-UI](https://img.shields.io/badge/Supabase-Auth%20%26%20DB-3ECF8E?style=flat-square&logo=supabase)](https://supabase.com/ui/docs/nextjs/password-based-auth)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-06B6D4?style=flat-square&logo=tailwindcss)](https://tailwindcss.com/)
[![shadcn/ui](https://img.shields.io/badge/shadcn%2Fui-Latest-000000?style=flat-square)](https://ui.shadcn.com/)


**Self-Documentation** 
       
[/docs](./docs/)


A production-ready, modern full-stack application built with Next.js 15, Supabase authentication, and a comprehensive UI component library. This monorepo template provides a solid foundation for scalable web applications with best practices for authentication, testing, and deployment.
## ✨ Features

- 🔐 **Authentication**: Complete auth system with Supabase (email/password, magic links, social login)
- 🎨 **Modern UI**: Components built with shadcn/ui and Radix primitives
- ⚡ **Performance**: Next.js 15 with App Router, React 19, and Turbopack
- 📱 **Responsive**: Mobile-first design with Tailwind CSS v4
- 🔒 **Security**: Row Level Security (RLS) with middleware protection, Middleware, Check auth per user (supabase) when page is protected
- 🧪 **Testing**: Comprehensive test suite with Vitest, Playwright
- 📦 **Monorepo**: Turborepo with shared packages and workspaces

## 📁 Project Structure

```
    ├──  (auth)/
    │   ├──  confirm/
    │   │   └──  route.ts
    │   ├──  error/
    │   │   └──  page.tsx
    │   ├──  forgot-password/
    │   │   └──  page.tsx
    │   ├──  login/
    │   │   └──  page.tsx
    │   ├──  logout/
    │   │   └──  route.ts
    │   ├──  sign-up/
    │   │   └──  page.tsx
    │   ├──  sign-up-success/
    │   │   └──  page.tsx
    │   ├──  update-password/
    │   │   └──  page.tsx
    │   └──  verification-success/
    │       └──  page.tsx
    ├──  (protected)/
    │   ├──  account/
    │   │   └──  page.tsx
    │   ├──  dashboard/
    │   │   └──  page.tsx
    │   ├──  invitation/
    │   │   ├──  page.tsx
    │   │   └──  success/
    │   │       └──  page.tsx
    │   ├──  invitee-setup-password/
    │   │   ├──  page.tsx
    │   │   └──  success/
    │   │       └──  page.tsx
    │   ├──  onboarding/
    │   │   └──  page.tsx
    │   └──  patients/
    │       ├──  create/
    │       │   ├──  page.tsx
    │       │   ├──  subscribe/
    │       │   │   └──  page.tsx
    │       │   └──  success/
    │       │       └──  page.tsx
    │       └──  import-medical-history/
    │           ├──  page.tsx
    │           └──  success/
    │               └──  page.tsx


```

## 🚀 Quick Start

1. **Git clone, `pnpm install` (from root)**

### **pnpm**
_for CODE_
   - `turbo`, 
   - `apps/**`, 
   - `packages/**`
   - see multiple `package.json` scripts for a better understanding

### **npx** 
_for infra_ AND CLAUDE

#### supabase 
   ```zsh
   npx supabase login
   npx supabase link
         ... choose web (if manipulating ovet/apps/web)
   ```
#### vercel

```zsh
   npx vercel auth
   cd apps/web
   npx vercel link

   npx vercel env pull # PROD SUPABASE credentials, watch out. 
   
      ... choose web (if manipulating ovet/apps/web)
   ```
#### claude code
TODO


## 📖 Documentation

- **[📚 Documentation Index](./docs/)** - Complete documentation overview
- **[🔐 Authentication Guide](./docs/auth/)** - Supabase auth implementation
- **[🛠️ Development Guides](./docs/development/)** - Setup and contribution guides

## 🏗️ Tech Stack

| Category            | Technology      | Purpose                               |
| ------------------- | --------------- | ------------------------------------- |
| **Framework**       | Next.js 15      | React framework with App Router       |
| **Runtime**         | React 19        | Latest React with concurrent features |
| **Language**        | TypeScript 5.7  | Type safety and developer experience  |
| **Database**        | Supabase        | PostgreSQL with real-time features    |
| **Authentication**  | Supabase Auth   | Complete auth solution with RLS       |
| **Styling**         | Tailwind CSS v4 | Utility-first CSS framework           |
| **Components**      | shadcn/ui       | Accessible component library          |
| **Icons**           | Lucide React    | Modern icon library                   |
| **Monorepo**        | Turborepo       | Build optimization and caching        |
| **Package Manager** | pnpm 10.+       | Fast, efficient package management    |

## 🧩 Using Components

### Adding Components

Components are automatically placed in `packages/ui/src/components/` and shared across the monorepo.

### Importing Components

Use components from the shared UI package:

```tsx
import { Button } from "@workspace/ui/components/button";
import { Card } from "@workspace/ui/components/card";
import { Dialog } from "@workspace/ui/components/dialog";
```

## 🔧 Development Commands

```bash
# Development
pnpm dev          # Start all development servers
pnpm build        # Build all apps and packages
pnpm lint         # Run ESLint across workspaces
pnpm format       # Format code with Prettier

# Testing
pnpm test         # Run unit tests
pnpm test:coverage # Run tests with coverage
pnpm test:e2e     # Run E2E tests with Playwright

# Web App Specific
cd apps/web
pnpm typecheck    # TypeScript validation
pnpm lint:fix     # Auto-fix ESLint issues
```

## 🏗️ Architecture

This monorepo follows modern best practices:

- **Turborepo** for fast, incremental builds
- **Workspace packages** for code sharing
- **Path aliases** for clean imports
- **Shared configurations** for consistency
- **SSR authentication with Supabase-UI components** [supabase-ui](https://supabase.com/ui/docs/nextjs/password-based-auth)

### Vercel

1. **WebApp Deployement (for now)**
   i. apps/web --> one vercel project
   ii. apps/tools (later, as an exemple here) --> one vercel project
2. **Set environment variables** [Vercel-Supabase Integration](https://vercel.com/ovet/~/integrations/supabase/icfg_6gQ7iVrie3yJVqFP2Avca03i)
3. **Deploy** - automatic builds on push to main

See [architecture diagrams](./docs/architecture/diagrams.md) for visual representations.

## 🔐 Authentication

Built-in authentication system with:

- **Email/Password**: Traditional signup and login
- **Magic Links**: Passwordless authentication via email
- **Protected Routes**: Middleware-based route protection
- **Session Management**: Automatic session refresh and state management
- **Row Level Security**: Database-level access control

## 🧪 Testing

The project includes comprehensive testing setup:

### Unit & Integration Tests

```bash
pnpm test              # Run all tests
```

### End-to-End Tests

```bash
pnpm test:e2
pnpm test:e2e:ui # run tests and open html pages with results
```

### Test Structure

- **Unit Tests**: Component and utility function tests
- **Integration Tests**: API routes and database operations
- **E2E Tests**: Complete user flows and authentication

## 🔒 Security

### Authentication Security

- **Row Level Security (RLS)**: Database-level access control
- **JWT Tokens**: Secure session management
- **CSRF Protection**: Built-in Next.js protection
- **Secure Cookies**: HTTP-only, secure cookie settings
- **Route Protection**: Middleware-based authentication checks

### Best Practices

- Environment variables for sensitive data
- Validated user inputs with type checking
- Secure password policies
- Email verification for new accounts
- Rate limiting on authentication endpoints

## 🚀 Deployment

### Code Standards

- Follow TypeScript best practices
- Write tests for new features
- Update documentation as needed
- Follow conventional commit messages
- Ensure all tests pass

## 📄 License

This project is licensed under the [MIT License](./LICENSE).




## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/) for the amazing React framework
- [Supabase](https://supabase.com/) for backend-as-a-service
- [shadcn/ui](https://ui.shadcn.com/) for beautiful components
- [Tailwind CSS](https://tailwindcss.com/) for utility-first styling
- [Vercel](https://vercel.com/) for seamless deployment
