# PreLoved Market — Design System

## App Overview

**PreLoved Market** is a second-hand fashion marketplace for campus students. The design reflects sustainability, warmth, and trust — inviting students to buy and sell pre-owned clothing, shoes, and accessories within their campus community.

---

## Colour Palette

| Role | Name | Hex Code | Usage |
|------|------|----------|-------|
| **Primary** | Forest Green | `#2D6A4F` | App bar, primary buttons, active icons, key CTAs |
| **Primary Container** | Soft Sage | `#B7E4C7` | Selected chips, active filter backgrounds, highlighted cards |
| **Secondary** | Warm Terracotta | `#C17754` | Accent buttons, price tags, condition badges, secondary actions |
| **Secondary Container** | Peach Cream | `#FADED3` | Secondary card highlights, notification badges |
| **Background** | Warm Linen | `#FDF6EC` | Main screen background across all pages |
| **Surface** | Off White | `#FFFFFF` | Cards, bottom sheets, dialogs, form fields |
| **On Primary** | White | `#FFFFFF` | Text/icons on primary-coloured elements |
| **On Background** | Charcoal Brown | `#2C2C2C` | Primary body text, headings |
| **On Surface Variant** | Muted Olive | `#6B7B6E` | Secondary text, captions, timestamps, placeholders |
| **Error** | Warm Red | `#C0392B` | Form validation errors, destructive actions |
| **Outline** | Soft Grey | `#D5CDBA` | Card borders, dividers, input field outlines |

---

## Typography

| Style | Font | Weight | Size | Usage |
|-------|------|--------|------|-------|
| **Display Large** | Poppins | Bold (700) | 28sp | App name on splash/onboarding |
| **Headline Medium** | Poppins | SemiBold (600) | 22sp | Screen titles (Home, Product Details) |
| **Title Medium** | Poppins | SemiBold (600) | 16sp | Card titles, section headers |
| **Body Large** | Poppins | Regular (400) | 16sp | Product descriptions, form labels |
| **Body Medium** | Poppins | Regular (400) | 14sp | General body text, chat messages |
| **Label Large** | Poppins | Medium (500) | 14sp | Button text, navigation labels |
| **Label Small** | Poppins | Regular (400) | 12sp | Captions, timestamps, condition badges |

---

## Component Styles

### Cards
- **Corner Radius:** 16px
- **Elevation:** 1 (subtle shadow)
- **Background:** Surface (`#FFFFFF`)
- **Border:** 1px `#D5CDBA` (Outline)
- **Padding:** 12px internal padding
- **Image Radius:** 12px (top corners for product images)

### Buttons
- **Primary Button:** Background `#2D6A4F`, text `#FFFFFF`, corner radius 12px, height 48px
- **Secondary Button:** Background `#C17754`, text `#FFFFFF`, corner radius 12px, height 48px
- **Outlined Button:** Border `#2D6A4F`, text `#2D6A4F`, corner radius 12px, height 48px

### Input Fields
- **Corner Radius:** 12px
- **Border:** 1px `#D5CDBA`, focused border `#2D6A4F`
- **Background:** `#FFFFFF`
- **Label Style:** Poppins Regular 14sp, colour `#6B7B6E`
- **Error Style:** Poppins Regular 12sp, colour `#C0392B`

### Condition Badges
- **Like New:** Background `#B7E4C7`, text `#2D6A4F`
- **Good:** Background `#FADED3`, text `#C17754`
- **Fair:** Background `#FFE8CC`, text `#A0522D`

### Bottom Navigation Bar
- **Background:** `#FFFFFF`
- **Active Icon:** `#2D6A4F` (Forest Green)
- **Inactive Icon:** `#6B7B6E` (Muted Olive)
- **Labels:** Poppins Medium 12sp

---

## Iconography

- **Icon Set:** Material Icons (filled variant for active, outlined for inactive)
- **Icon Size:** 24px (navigation), 20px (inline)
- **Icon Colour:** Follows active/inactive state from the palette above

---

## Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Tight gaps between inline elements |
| `sm` | 8px | Icon-to-text spacing, badge padding |
| `md` | 12px | Card internal padding |
| `lg` | 16px | Section spacing, screen edge padding |
| `xl` | 24px | Between major sections on a screen |
| `xxl` | 32px | Top/bottom screen breathing room |

---

## Design Rationale

PreLoved Market's visual identity is rooted in warmth and sustainability. We chose **Forest Green** as the primary colour because green is universally associated with environmental consciousness and renewal — core values of second-hand fashion. The **Warm Terracotta** secondary colour adds an earthy, approachable energy that prevents the palette from feeling clinical or overly corporate. Together, these tones echo the experience of browsing a well-curated thrift market: natural, inviting, and full of character.

The **Warm Linen** background gives the app a soft, fabric-like warmth that feels distinct from the harsh white backgrounds of typical e-commerce apps. This deliberate choice reinforces the "pre-loved" identity — items with history and personality, not sterile factory goods. **Poppins** was selected as the typeface for its clean geometry and friendly roundness, which balances readability with a modern, youthful feel appropriate for a campus audience.

Card components use generous corner radii (16px) and subtle borders rather than heavy drop shadows, creating a light, breathable interface that lets product photos take centre stage. Condition badges use colour-coded backgrounds drawn from the palette, making quality assessment instant and visual — directly addressing the trust and transparency friction identified in our field research with Emmanuel and Kaneza Devine.

---

## Currency & Localization

* All prices are displayed in **Rwandan Franc (RWF)** to reflect the local campus context.
* Price format: `8,000 RWF` (no currency symbols or icons are used).
* This improves clarity and ensures familiarity for student users.
* Numbers are formatted with commas for readability (e.g., 12,500 RWF instead of 12500).

This decision supports usability and aligns the app with real-world student buying behavior in Rwanda.

---

## Key UX Focus

The design prioritizes simplicity and speed, allowing users to quickly browse items, view details, and contact sellers without unnecessary steps. The interface reduces cognitive load by keeping layouts clean and consistent across all screens.
