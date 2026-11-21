---
name: Editorial Utility
colors:
  surface: '#f9f9f8'
  surface-dim: '#dadad9'
  surface-bright: '#f9f9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f3'
  surface-container: '#eeeeed'
  surface-container-high: '#e8e8e7'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#414944'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f1f0'
  outline: '#717973'
  outline-variant: '#c0c8c2'
  surface-tint: '#3b6752'
  primary: '#023423'
  on-primary: '#ffffff'
  primary-container: '#1e4b38'
  on-primary-container: '#8bbaa2'
  inverse-primary: '#a1d1b8'
  secondary: '#585f65'
  on-secondary: '#ffffff'
  secondary-container: '#dae0e7'
  on-secondary-container: '#5c6369'
  tertiary: '#5a1300'
  on-tertiary: '#ffffff'
  tertiary-container: '#782912'
  on-tertiary-container: '#ff9375'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bdedd3'
  primary-fixed-dim: '#a1d1b8'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#224f3c'
  secondary-fixed: '#dde3ea'
  secondary-fixed-dim: '#c0c7ce'
  on-secondary-fixed: '#161c21'
  on-secondary-fixed-variant: '#41484d'
  tertiary-fixed: '#ffdbd1'
  tertiary-fixed-dim: '#ffb5a0'
  on-tertiary-fixed: '#3b0900'
  on-tertiary-fixed-variant: '#7d2c15'
  background: '#f9f9f8'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  headline-xl:
    fontFamily: Newsreader
    fontSize: 34px
    fontWeight: '500'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Newsreader
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Newsreader
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 30px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Newsreader
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.005em
  headline-sm:
    fontFamily: Newsreader
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-stamp:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes an editorial, utility-first career marketplace interface. Drawing philosophical inspiration from Things 3, Linear, and Quartz, it replaces high-gloss AI tropes (neon gradients, purple glows, translucent glassmorphism, floating blobs) with tactile, warm paper discipline and considered typographic rhythm.

The audience consists of driven professionals seeking intentional next steps in their careers. The emotional tone is calm, credible, and direct—treating job recommendations like curated editorial dispatches rather than gamified casino mechanics. The interface uses crisp hairline dividers, quiet surfaces, and decisive stamp indicators to deliver focus, speed, and elevated utility.

## Colors

The color palette is grounded in print and editorial paper stock:
- **Primary (`#1E4B38`)**: Deep Spruce Green. Used for primary actions, selected states, match indicators, and positive decision stamps ('INTERESTED').
- **Secondary (`#636A70`)**: Muted Slate. Used for supporting metadata, passive icons, and rejection stamps ('PASS').
- **Tertiary (`#A84C32`)**: Brick Oxide. Used sparingly for urgent deadlines, expiring listings, and critical alerts.
- **Neutral Light (`#FBFBFA`)**: Warm Newsprint Paper. Forms the foundational background, avoiding harsh clinical whites. Paired with `#141615` for body text and `#E5E5E2` for structural hairline borders.
- **Neutral Dark (`#121314`)**: Rich Charcoal. Serves as dark-mode canvas with `#222527` elevated cards, `#323639` hairline strokes, and `#EAEAE7` high-contrast text.

Color is strictly functional; surface fills remain opaque, and ornamental blurs are prohibited.

## Typography

The type system blends the editorial authority of **Newsreader** with the systematic clarity of **Inter**:
- **Headlines (Newsreader)**: Renders job titles, executive summaries, publication names, and screen titles. Uses medium and semi-bold weights with tightened tracking for an ink-and-paper feel.
- **Body & Data (Inter)**: Handles job requirements, company profiles, compensation structures, and match rationale. Prioritizes legibility at dense scales.
- **Stamps & Status (`label-stamp`)**: Set entirely in uppercase Inter with wide tracking (`0.08em`) to mirror physical verification stamps and editorial flags.

## Layout & Spacing

A disciplined 4pt vertical rhythm organizes the mobile-first viewport:
- **Base Grid**: 4-column layout on mobile with `1.25rem` (20px) outer canvas margins and `1rem` (16px) gutters. Content stretches fluidly within safe viewport boundaries.
- **Component Gaps**:
  - `space-xs` (4px): Inner badge padding, micro metadata gaps.
  - `space-sm` (8px): Icon-to-text gaps, list item vertical paddings.
  - `space-md` (16px): Card internal padding, field separation.
  - `space-lg` (24px): Card-to-control distance, section stacking.
  - `space-xl` (32px): Major contextual block breaks.
- **Responsive Adaptations**:
  - Mobile (360px–480px): Single stacked card swipe container; bottom fixed tool tray.
  - Tablet/Desktop Web (768px+): Restrained 540px centered mobile deck canvas flanked by secondary editorial notes and hotkey instructions.

## Elevation & Depth

Visual hierarchy is constructed entirely through **tonal separation and crisp 1px hairline borders**, explicitly rejecting heavy drop shadows and glowing aura effects:
- **Base Layer**: Default warm paper background (`#FBFBFA` in light, `#121314` in dark).
- **Surface Layer 1 (Cards & Modules)**: Pure white `#FFFFFF` (light) or `#1E2022` (dark) bound by a precise 1px solid hairline (`#E5E5E2` / `#2F3235`).
- **Tactile Deck Shadow**: For draggable swipe cards only, a minimal, physical paper shadow is applied: `0 4px 12px rgba(18, 19, 20, 0.05), 0 1px 2px rgba(18, 19, 20, 0.03)`. When dragged, shadow subtly tightens rather than glows.
- **Dividers & Separators**: 1px single-pixel lines without falloff or gradients.

## Shapes

The design system enforces a strict 3-tier geometry:
- **Tier 1 (4px)**: Micro elements—metadata badges, category chips, stamp outlines, and skill tags.
- **Tier 2 (8px)**: Interactive controls—primary and secondary action buttons, text input fields, selection toggles, and dropdown menus.
- **Tier 3 (16px)**: Canvas structures—main job swipe cards, persistent bottom sheets, and dialog surfaces.

Zero circular pills are used for core interactive buttons; edges remain structured and architecture-inspired.

## Components

### Swipe Cards (Career Decks)
- **Container**: 16px corner radius, `#FFFFFF` fill (`#1E2022` dark), 1px stroke `#E5E5E2`.
- **Header**: Company name in `label-md` uppercase slate; role title in `headline-lg` Newsreader.
- **Content Blocks**: Salary and location paired on an inline divider; role synthesis summary in `body-md` Inter with 1.5 line height.
- **AI Match Ledger**: A dedicated hairline-bordered inset section detailing "Why this fits" with check marks in `#1E4B38`.

### Decision Stamp Badges
- **Style**: 4px radius, 1.5px solid border, set with `label-stamp` (all caps, wide tracking).
- **'INTERESTED' Stamp**: Deep Spruce Green border and text (`#1E4B38`) on `rgba(30, 75, 56, 0.06)` background.
- **'PASS' Stamp**: Muted Slate border and text (`#636A70`) on `rgba(99, 106, 112, 0.06)` background.
- **Placement**: Fixed top corners during active swipe threshold gestures.

### Action Buttons
- **Primary ("Apply" / "Save")**: Deep Spruce Green background (`#1E4B38`), crisp white text, 8px radius, height 48px, zero gradients. Active state: `#153527`.
- **Secondary / Pass**: 1px solid hairline border `#E5E5E2`, transparent background, secondary text `#141615`.
- **Ghost Utility**: Flat, text-only with 4px focus ring for bookmarking, filter resets, and navigation.

### Chips & Badges
- **Form**: 4px radius, `0.25rem` vertical and `0.5rem` horizontal padding.
- **Appearance**: Light neutral fill (`#F2F2EE`), borderless, text in `label-md` `#444746`. Selected state switches to spruce outline with matching text.

### Text Inputs & Search
- **Container**: 8px radius, 44px height, `#FFFFFF` background, 1px `#E5E5E2` border.
- **Focus State**: 1.5px solid `#1E4B38`, no halo glow.
- **Typography**: `body-md` with slate placeholder (`#8C9296`).

### Checkboxes & Segmented Controls
- **Checkboxes**: 4px radius square, 1px border. Checked state fills `#1E4B38` with an interior white mark.
- **Segmented Control**: Flat recessed container (`#EEEEEC`) with 8px radius holding white segmented tabs with 6px radius and subtle 1px hairline border.