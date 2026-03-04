# CSF3 Story Format (Storybook v7+)

## Basic structure

```typescript
import type { Meta, StoryObj } from '@storybook/react'
import { Button } from './Button'

// Meta — configures the component in Storybook
const meta: Meta<typeof Button> = {
  component: Button,
  tags: ['autodocs'],       // enables auto-generated docs page
}
export default meta

// Story type
type Story = StoryObj<typeof Button>

// Stories — each named export is a story
export const Default: Story = {
  args: {
    label: 'Click me',
    variant: 'primary',
  },
}

export const Disabled: Story = {
  args: {
    label: 'Disabled',
    disabled: true,
  },
}
```

## With argTypes (interactive controls)

```typescript
const meta: Meta<typeof Button> = {
  component: Button,
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'danger'],
    },
    onClick: { action: 'clicked' },
  },
}
```

## Composition (render function)

Use when args alone aren't sufficient:

```typescript
export const WithIcon: Story = {
  render: (args) => (
    <Button {...args}>
      <Icon name="arrow-right" /> Continue
    </Button>
  ),
}
```

## Decorators (wrap with context)

```typescript
const meta: Meta<typeof Component> = {
  component: Component,
  decorators: [
    (Story) => (
      <ThemeProvider theme="dark">
        <Story />
      </ThemeProvider>
    ),
  ],
}
```

## Common story variants to cover

| State | When to add |
|---|---|
| `Default` | Always — minimal required props |
| `Loading` | When component has loading state |
| `Empty` | When component handles empty data |
| `Error` | When component has error state |
| `Disabled` | When component can be disabled |
| `LongContent` | When overflow behavior matters |
