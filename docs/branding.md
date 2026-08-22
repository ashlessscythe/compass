# Branding

## Wordmark

**Compass**

Primary product name. Hero-level signal on marketing surfaces — never demoted to a quiet nav-only label when the page is introducing the product.

## Tagline

**Know where everything is.**

## Domain

**getcompass.space**

Canonical production URL: `https://getcompass.space`

## Icon

A modern, geometric compass mark:

- Circular outline
- Cardinal axes with a clear north accent
- Center point
- Minimal stroke language

Source SVG: `apps/web/public/icon.svg`. Regenerate web + iOS/macOS app icons with `pnpm icons` ([scripts/generate-icons.mjs](../scripts/generate-icons.mjs)). App Store icons are square opaque RGB (no alpha).

**Home screen vs product name:** the in-app wordmark and marketing site stay **Compass**. iOS `CFBundleDisplayName` is **Compass Inventory** because App Store Connect rejects the short name `Compass` (ITMS-90129). Keep `CFBundleName` as `mobile` for continuity with existing TestFlight builds. Bundle id stays `app.compass.mobile`.

Do **not** use fantasy, medieval, parchment, or TCG-ornament styling for the core brand. Vertical modules may use playful imagery in-product; the Compass brand itself stays premium software.

## Visual language

Inspired by Apple, Linear, Raycast, Arc, and Vercel:

- Dark mode first
- Large typography
- Generous spacing
- Subtle motion (fade, parallax, blur, gradient drift)
- Glass surfaces where they clarify hierarchy
- Soft noise texture for depth
- Cool steel / blue accent — not purple-default AI aesthetics

## Typography

| Role    | Family         |
|---------|----------------|
| Display | Space Grotesk  |
| UI      | Geist          |
| Body    | Inter          |

## Color tokens

See `@compass/branding` (`packages/branding/src/tokens.ts`):

- Background: near-black `#0A0B0D`
- Foreground: soft white `#F4F5F7`
- Accent: `#5B8DEF`
- Muted text: `#9AA3B2`

## Voice

- Clear, confident, concise
- Product-led, not hype-led
- Speaks to collectors and organizers who care about craft
- Avoids gimmicks and medieval fantasy tropes
