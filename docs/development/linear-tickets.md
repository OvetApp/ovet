# Linear Ticket Creation Framework

Automated ticket creation system for the Ovet Web App with smart defaults and context-aware improvements.

## Quick Usage

### Basic Syntax

```
Create ticket: [vague title]
Create ticket: [vague title] | [optional description]
```

### Examples

```bash
# Simple title - description auto-generated
"Create ticket: fix login bug"

# Title with custom description
"Create ticket: improve navigation | Users getting confused in auth flow"

# Complex feature request
"Create ticket: add dark mode | Need theme switching for better UX"
```

## Framework Details

### Smart Defaults

- **Team**: Web App (`cf38dffe-55b9-4ce3-a057-b7d33f9b492d`)
- **Project**: Ovet Web Migration to Monorepo (`b4631f12-d0f4-409b-a3e6-b00854dcc508`)
- **Priority**: 3 (Medium)
- **Status**: Triage (automatic)

### Context-Aware Enhancement

#### Title Improvement

The system enhances vague titles using project context:

| Input               | Enhanced Output                           |
| ------------------- | ----------------------------------------- |
| "fix login bug"     | "Fix authentication login validation bug" |
| "improve nav"       | "Improve navigation UX flow"              |
| "add dark mode"     | "Add dark mode theme switching"           |
| "performance issue" | "Fix performance bottleneck in page load" |

#### Description Generation

When no description provided, generates based on:

- **Current tech stack** (Next.js 15, Supabase, shadcn/ui)
- **Architecture patterns** (App Router, middleware, SSR)
- **Project requirements** (monorepo migration, auth enhancement)

**Auto-generated sections:**

- **Context** - Technical background
- **Acceptance Criteria** - Testable requirements
- **Technical Notes** - Implementation guidance

### Example Generated Ticket

**Input:** `"fix navigation"`

**Generated:**

```markdown
Title: Fix navigation routing and UX flow

Description:
Based on the monorepo architecture, fix navigation issues and enhance
user experience for smoother transitions between app states.

**Context:**

- Current monorepo setup with Next.js 15 App Router
- Supabase authentication with middleware protection
- Need better UX for incoming users per project requirements

**Acceptance Criteria:**

- [ ] Fix navigation routing issues
- [ ] Smooth transitions between auth states
- [ ] Consistent navigation patterns
- [ ] Mobile-responsive navigation

**Technical Notes:**

- Use existing middleware.ts patterns
- Leverage App Router capabilities
- Follow current component conventions
```

## Advanced Usage

### Custom Priority

```bash
# High priority ticket
"Create urgent ticket: critical auth bug | Users can't log in"

# Low priority enhancement
"Create low-priority ticket: improve animations | Polish UI transitions"
```

### Specific Project Assignment

```bash
# Different project (if needed)
"Create ticket for billing: payment flow | Stripe integration issues"
```

### Team Assignment

```bash
# Assign to different team
"Create iOS ticket: sync with web | Native app parity"
```

## Technical Implementation

### Core Function

```typescript
async function createSmartTicket(
  title: string,
  description?: string,
): Promise<LinearTicket> {
  const enhancedTitle = enhanceTitle(title);
  const enhancedDescription = description || generateDescription(title);

  return await createLinearIssue({
    title: enhancedTitle,
    description: enhancedDescription,
    teamId: WEB_APP_TEAM_ID,
    projectId: MONOREPO_PROJECT_ID,
    priority: 3,
  });
}
```

### Context Enhancement Engine

The system uses:

- **Project knowledge** from CLAUDE.md and docs/
- **Architecture patterns** from codebase structure
- **Current requirements** from project description
- **Technical stack** (Next.js 15, Supabase, Turborepo)

## Usage Examples

### Development Workflow

```bash
# During code review
"Create ticket: refactor auth components | Too much duplication in forms"

# Bug found during testing
"Create ticket: middleware redirect loop | Users stuck in auth flow"

# Feature request from user feedback
"Create ticket: add loading states | Users confused by no feedback"
```

### Project Management

```bash
# Planning session
"Create ticket: audit component library | Check shadcn/ui coverage"

# Architecture decision
"Create ticket: database schema review | Plan for user roles expansion"
```

## Integration with CLAUDE.md

Add to your workflow commands:

```bash
# Custom Slash Commands
/ticket [title] | [description]  # Create smart Linear ticket
/urgent [title] | [description]  # High priority ticket
/bug [title] | [description]     # Bug-specific ticket with template
```

## Ticket Templates

### Bug Report Template

```markdown
**Bug Description:**
[Auto-generated based on title]

**Steps to Reproduce:**

1. [Inferred from context]
2. Navigate to affected area
3. Observe issue

**Expected Behavior:**
[Generated from requirements]

**Actual Behavior:**
[Issue description]

**Environment:**

- Next.js 15 App Router
- Supabase Auth
- [Browser/Device if specified]
```

### Feature Request Template

```markdown
**Feature Description:**
[Enhanced based on title and context]

**User Story:**
As a [user type], I want [feature] so that [benefit]

**Acceptance Criteria:**

- [ ] [Generated checklist]
- [ ] Mobile responsive
- [ ] Accessible design
- [ ] Error handling

**Technical Considerations:**

- Follow existing patterns
- Use shadcn/ui components
- Maintain TypeScript safety
```

## Best Practices

### Effective Titles

- **Be specific**: "login validation" vs "auth issue"
- **Include context**: "mobile navigation" vs "navigation"
- **Action-oriented**: "fix", "add", "improve", "refactor"

### Useful Descriptions

- **Provide context** even if brief
- **Mention user impact** when relevant
- **Include technical constraints** if any
- **Reference related work** if applicable

### Workflow Integration

1. **During development** - Create tickets for discovered issues
2. **Code reviews** - Generate tickets for refactoring needs
3. **User feedback** - Convert feedback to actionable tickets
4. **Planning** - Break down features into tickets

This framework streamlines ticket creation while maintaining quality and consistency across the Web App project.
