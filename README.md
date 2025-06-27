# Ovet - Turborepo Monorepo with Next.js 15 & Supabase

[![Next.js](https://img.shields.io/badge/Next.js-15-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19-61DAFB?style=flat-square&logo=react)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-3178C6?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Auth%20%26%20DB-3ECF8E?style=flat-square&logo=supabase)](https://supabase.com/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.0-06B6D4?style=flat-square&logo=tailwindcss)](https://tailwindcss.com/)
[![shadcn/ui](https://img.shields.io/badge/shadcn%2Fui-Latest-000000?style=flat-square)](https://ui.shadcn.com/)

A production-ready, modern full-stack application built with Next.js 15, Supabase authentication, and a comprehensive UI component library. This monorepo template provides a solid foundation for scalable web applications with best practices for authentication, testing, and deployment.

## ✨ Features

- 🔐 **Authentication**: Complete auth system with Supabase (email/password, magic links, social login)
- 🎨 **Modern UI**: Components built with shadcn/ui and Radix primitives
- ⚡ **Performance**: Next.js 15 with App Router, React 19, and Turbopack
- 🎭 **Theming**: Dark/light mode support with next-themes
- 📱 **Responsive**: Mobile-first design with Tailwind CSS v4
- 🔒 **Security**: Row Level Security (RLS) with middleware protection, Middleware, Check auth per user (supabase) when page is protected
- 🧪 **Testing**: Comprehensive test suite with Vitest, Playwright
- 📦 **Monorepo**: Turborepo with shared packages and workspaces

## 📁 Project Structure

```
/
├── apps/
│   └── web/          # Next.js 15 application
├── packages/
│   ├── ui/           # Shared UI components
│   ├── eslint-config/ # Shared ESLint configuration
│   └── typescript-config/ # Shared TypeScript configuration
├── docs/             # Project documentation
└── CLAUDE.md         # Claude Code automation workflows
```


## 🚀 Quick Start

1. **Clone and install dependencies:**
   ```bash
   pnpm install
   ```

2. **Set up environment variables:**
   ```bash
   cp apps/web/.env.example apps/web/.env
   ```
   
   Add your Supabase credentials:
   ```env
   NEXT_PUBLIC_SUPABASE_URL="your-project-url"
   NEXT_PUBLIC_SUPABASE_ANON_KEY="your-anon-key"
   some other stuff later
   ```

3. **Start development servers:**
   ```bash
   pnpm dev
   ```

## 📖 Documentation

- **[📚 Documentation Index](./docs/)** - Complete documentation overview
- **[🔐 Authentication Guide](./docs/auth/)** - Supabase auth implementation
- **[🛠️ Development Guides](./docs/development/)** - Setup and contribution guides

## 🏗️ Tech Stack

| Category | Technology | Purpose |
|----------|------------|----------|
| **Framework** | Next.js 15 | React framework with App Router |
| **Runtime** | React 19 | Latest React with concurrent features |
| **Language** | TypeScript 5.7 | Type safety and developer experience |
| **Database** | Supabase | PostgreSQL with real-time features |
| **Authentication** | Supabase Auth | Complete auth solution with RLS |
| **Styling** | Tailwind CSS v4 | Utility-first CSS framework |
| **Components** | shadcn/ui | Accessible component library |
| **Icons** | Lucide React | Modern icon library |
| **Monorepo** | Turborepo | Build optimization and caching |
| **Package Manager** | pnpm 10.4+ | Fast, efficient package management |

## 🧩 Using Components

### Adding Components

Components are automatically placed in `packages/ui/src/components/` and shared across the monorepo.

### Importing Components
Use components from the shared UI package:

```tsx
import { Button } from "@workspace/ui/components/button"
import { Card } from "@workspace/ui/components/card"
import { Dialog } from "@workspace/ui/components/dialog"
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
- **SSR authentication** with Supabase

### Vercel
1. **WebApp Deployement (for now)**
	i. apps/web --> one vercel project
	ii. apps/tools (later, as an exemple here) --> one vercel project
2. **Set environment variables** in vercel dashboard (for now) 
3. **Deploy** - automatic builds on push to main

See [architecture diagrams](./docs/architecture/diagrams.md) for visual representations.

## 🔐 Authentication

Built-in authentication system with:

- **Email/Password**: Traditional signup and login
- **Magic Links**: Passwordless authentication via email
- **Social Login**: GitHub, Google, and other OAuth providers
- **Protected Routes**: Middleware-based route protection
- **Session Management**: Automatic session refresh and state management
- **Row Level Security**: Database-level access control

### Key Pages

- `/` - Public landing page
- `/auth/login` - User login
- `/auth/sign-up` - User registration
- `/auth/forgot-password` - Password reset
- `/protected` - Example protected page
- `/auth/confirm` - Email confirmation handler

Learn more in the [authentication documentation](./docs/auth/).

## 🧪 Testing

The project includes comprehensive testing setup:

### Unit & Integration Tests
```bash
pnpm test              # Run all tests
pnpm test:coverage     # Run with coverage report
pnpm test:ui           # Run with Vitest UI
```

### End-to-End Tests
```bash
pnpm test:e2e          # Run Playwright tests
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

## 🔗 Links

- [Live Demo](https://your-demo-url.vercel.app)
- [Documentation](https://your-docs-url.com)
- [Issue Tracker](https://github.com/your-username/ovet/issues)
- [Discussions](https://github.com/your-username/ovet/discussions)

- **Documentation:** [/docs](./docs/)
- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions

## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/) for the amazing React framework
- [Supabase](https://supabase.com/) for backend-as-a-service
- [shadcn/ui](https://ui.shadcn.com/) for beautiful components
- [Tailwind CSS](https://tailwindcss.com/) for utility-first styling
- [Vercel](https://vercel.com/) for seamless deployment


