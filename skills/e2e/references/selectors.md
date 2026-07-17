# Selector Strategy for Cypress

## Priority order (most to least preferred)

### 1. Role + name — `@testing-library/cypress`

Mirrors how assistive technologies see the page. Resilient to style changes.

```typescript
cy.findByRole('button', { name: 'Submit' })
cy.findByRole('textbox', { name: 'Email' })
cy.findByRole('heading', { name: 'Sign in' })
cy.findByRole('link', { name: 'Home' })
cy.findByRole('checkbox', { name: 'Remember me' })
```

### 2. Label — forms

```typescript
cy.findByLabelText('Email address')
cy.findByLabelText('Password')
```

### 3. Text content

```typescript
cy.findByText('Welcome back')
cy.findByText(/welcome/i)   // regex for case-insensitive
```

### 4. Placeholder

```typescript
cy.findByPlaceholderText('Search...')
```

### 5. `data-testid` — last resort

Use when there's no accessible label and adding one isn't feasible.

```typescript
cy.get('[data-testid="submit-button"]')

// Renders as:
// <button data-testid="submit-button">Submit</button>
```

## Why avoid CSS selectors

```typescript
// Fragile — breaks on refactor or style change
cy.get('.btn-primary')
cy.get('#submit')
cy.get('form > div:nth-child(2) > input')

// Resilient — describes behavior, not structure
cy.findByRole('button', { name: 'Submit' })
```
