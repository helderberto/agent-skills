---
name: storybook
description: Generate Storybook stories for UI components. Use when user asks to "create a story", "/storybook", "add stories", "document this component", or wants to add a component to Storybook.
compatibility: Requires Storybook v7+ configured in the project.
allowed-tools: Read Glob Grep Write
---

# Generate Storybook Stories

## Detection

Run in parallel:
- Check `package.json` for `@storybook/react`, `@storybook/vue3`, etc. and version
- Read component file to understand props/types
- Read 1-2 existing story files to match project conventions

## Workflow

1. Read the target component — extract all props and their types
2. Read existing stories for style reference
3. Generate stories in CSF3 format (see [csf3-format.md](references/csf3-format.md)):
   - `Default` — component with minimal/required props
   - State variants — loading, error, empty, disabled (if applicable)
   - Prop matrix — key prop combinations worth documenting
4. Add `argTypes` for interactive controls on important props

## CSF3 template

```typescript
import type { Meta, StoryObj } from '@storybook/react'
import { ComponentName } from './ComponentName'

const meta: Meta<typeof ComponentName> = {
  component: ComponentName,
}
export default meta

type Story = StoryObj<typeof ComponentName>

export const Default: Story = {
  args: {
    // required props here
  },
}
```

## Rules

- Read the component before writing — match actual prop names and types
- Cover meaningful states, not every prop permutation
- Use `args` (not render functions) unless composition is required
- Match existing story file naming and export style
