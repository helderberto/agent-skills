# WCAG 2.1 Checklist

## Level A — Critical

### Images
- [ ] Every `<img>` has `alt` attribute
- [ ] Decorative images have `alt=""`
- [ ] Complex images (charts, diagrams) have detailed `alt` or linked description

### Forms
- [ ] Every input has an associated `<label>` (via `htmlFor`/`for` or `aria-label`)
- [ ] Required fields are indicated (not by color alone)
- [ ] Error messages are descriptive and linked to the field

### Interactive elements
- [ ] All interactive elements are focusable (no `tabindex="-1"` on clickable elements)
- [ ] No `<div onClick>` or `<span onClick>` — use `<button>` or `<a>`
- [ ] Links have descriptive text (not "click here" or "read more")
- [ ] Buttons have accessible names (text content or `aria-label`)

### Structure
- [ ] Page has a single `<h1>`
- [ ] Heading levels are not skipped (h1 → h2, not h1 → h3)
- [ ] Lists use `<ul>`/`<ol>`, not manual bullet characters

## Level AA — Serious

### Color & contrast
- [ ] Text contrast ratio ≥ 4.5:1 (normal text), ≥ 3:1 (large text 18pt+)
- [ ] Information is not conveyed by color alone (e.g. error states)
- [ ] Focus indicator is visible (not removed with `outline: none` without replacement)

### Navigation
- [ ] Skip-to-content link present
- [ ] Page landmarks present: `<main>`, `<nav>`, `<header>`, `<footer>`
- [ ] Navigation order is logical (matches visual order)

### Dynamic content
- [ ] Modal dialogs trap focus and return focus on close
- [ ] Loading states are announced to screen readers (`aria-live` or `aria-busy`)
- [ ] Error messages announced (not just shown visually)

## Common React patterns

```tsx
// Bad
<div onClick={handleClose}>×</div>

// Good
<button onClick={handleClose} aria-label="Close dialog">×</button>
```

```tsx
// Bad
<input type="text" placeholder="Email" />

// Good
<label htmlFor="email">Email</label>
<input id="email" type="email" />
```

```tsx
// Bad — color-only error
<input style={{ border: '1px solid red' }} />

// Good
<input aria-invalid="true" aria-describedby="email-error" />
<span id="email-error" role="alert">Email is required</span>
```
