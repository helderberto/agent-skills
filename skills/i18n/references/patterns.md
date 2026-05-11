# i18n Patterns by Library

## react-i18next

```tsx
import { useTranslation } from 'react-i18next'

function Component() {
  const { t } = useTranslation()

  return (
    <div>
      <h1>{t('dashboard.title')}</h1>
      <p>{t('dashboard.welcome', { name: user.name })}</p>
      <button aria-label={t('nav.closeMenu')}>×</button>
    </div>
  )
}
```

## next-intl

```tsx
import { useTranslations } from 'next-intl'

function Component() {
  const t = useTranslations('Dashboard')

  return <h1>{t('title')}</h1>
}

// Server component
import { getTranslations } from 'next-intl/server'

async function Page() {
  const t = await getTranslations('Dashboard')
  return <h1>{t('title')}</h1>
}
```

## react-intl (FormatJS)

```tsx
import { useIntl, FormattedMessage } from 'react-intl'

function Component() {
  const intl = useIntl()

  return (
    <div>
      <FormattedMessage id="dashboard.title" />
      <input placeholder={intl.formatMessage({ id: 'form.searchPlaceholder' })} />
    </div>
  )
}
```

---

## What counts as a hardcoded string (flag these)

```tsx
// Flag — user-visible text
<h1>Welcome back</h1>
<p>Your session has expired</p>
<button>Save changes</button>
<input placeholder="Search products..." />
<span aria-label="Close menu">×</span>
```

## What to ignore (not user-visible)

```tsx
// Skip — internal identifiers
className="text-primary"
data-testid="submit-button"
href="/dashboard"
type="submit"
console.log('debug')
const STATUS = 'active'
```

## Locale file structure

```json
{
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "loading": "Loading..."
  },
  "dashboard": {
    "title": "Dashboard",
    "welcome": "Welcome back, {{name}}"
  },
  "errors": {
    "networkTimeout": "Connection timed out. Please try again."
  }
}
```
