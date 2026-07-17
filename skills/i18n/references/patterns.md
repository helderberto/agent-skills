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
