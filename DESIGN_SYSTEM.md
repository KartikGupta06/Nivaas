# OFFICIAL DESIGN SYSTEM SPECIFICATION
## Nivaas — Mobile-First Society Management Platform

**Document Version:** 1.0.0  
**Status:** Official Design Reference (Single Source of Truth)  
**Target Platform:** Flutter Mobile (Android First, Material 3, iOS Support)  
**Authors:** Principal Product Designer, Senior Flutter UI Architect, Design System Architect, UX Researcher  
**Target Repository:** `KartikGupta06/Nivaas`

---

## Table of Contents
1. [Design Philosophy](#1-design-philosophy)
2. [Design Principles](#2-design-principles)
3. [Brand Personality](#3-brand-personality)
4. [User Experience Goals](#4-user-experience-goals)
5. [Visual Language](#5-visual-language)
6. [Color System](#6-color-system)
7. [Dark Mode Strategy](#7-dark-mode-strategy)
8. [Typography](#8-typography)
9. [Elevation System](#9-elevation-system)
10. [Corner Radius System](#10-corner-radius-system)
11. [Shadow System](#11-shadow-system)
12. [Spacing System](#12-spacing-system)
13. [Layout Rules](#13-layout-rules)
14. [Responsive Rules](#14-responsive-rules)
15. [Safe Area Rules](#15-safe-area-rules)
16. [Component Library](#16-component-library)
17. [Iconography](#17-iconography)
18. [Illustration Style](#18-illustration-style)
19. [Image Guidelines](#19-image-guidelines)
20. [Animation Guidelines](#20-animation-guidelines)
21. [Accessibility](#21-accessibility)
22. [Forms UX](#22-forms-ux)
23. [Dashboard Design Rules](#23-dashboard-design-rules)
24. [Card Design Rules](#24-card-design-rules)
25. [Table Design Rules](#25-table-design-rules)
26. [List Design Rules](#26-list-design-rules)
27. [Search Experience](#27-search-experience)
28. [Notification UX](#28-notification-ux)
29. [Empty State UX](#29-empty-state-ux)
30. [Offline Mode UX](#30-offline-mode-ux)
31. [Error Handling UX](#31-error-handling-ux)
32. [Loading UX](#32-loading-ux)
33. [Success UX](#33-success-ux)
34. [Navigation Guidelines](#34-navigation-guidelines)
35. [Role Based UI Differences](#35-role-based-ui-differences)
36. [Design Tokens](#36-design-tokens)
37. [Naming Convention](#37-naming-convention)
38. [Flutter Widget Recommendations](#38-flutter-widget-recommendations)
39. [UI Do's](#39-ui-dos)
40. [UI Don'ts](#40-ui-donts)
41. [Future Design Expansion](#41-future-design-expansion)
42. [Final Summary](#42-final-summary)

---

## 1. Design Philosophy

Nivaas strictly adheres to a **Utility-First, Accessible, Zero-Clutter Design Philosophy**.

Housing society operations in India involve diverse users: senior citizens approving delivery personnel, security watchmen under bright sunlight logging entries on low-end Android phones, and working professionals paying maintenance dues in a rush.

### Core Philosophy Guidelines:
- **Clarity over Decoration**: Every pixel must serve a functional purpose.
- **Cognitive Ease**: Zero unnecessary popups, floating promo banners, or intrusive ads.
- **Familiarity**: Draw inspiration from daily Indian utility products like **Google Pay**, **PhonePe**, **WhatsApp**, **Google Calendar**, and **Google Tasks**.
- **Explicit Anti-Patterns**:
  - ❌ NO Glassmorphism or blurry backdrop filters.
  - ❌ NO Neumorphism or extruded 3D shapes.
  - ❌ NO Cyberpunk / Gaming / Glowing HUD effects.
  - ❌ NO Micro-animations longer than 200ms.
  - ❌ NO Tiny icon-only actions without explicit text labels.

---

## 2. Design Principles

1. **One Tap Approval**: Primary user flows (e.g. approving a guest at the gate) must complete within a single tap from the home screen or notification lock screen.
2. **Extreme Sunlight Readability**: High-contrast ratios (minimum WCAG 2.1 AAA 7:1) to ensure watchmen can read screens outdoor at society gates.
3. **Ergonomic Thumb Placement**: All primary action buttons are anchored within the lower 35% of the screen.
4. **Resilient Offline Visibility**: Clear visual indicators for offline states with zero screen freezing or blocking spinners.
5. **Generous Touch Targets**: Minimum 48x48 dp touch boundaries for every interactive element.

---

## 3. Brand Personality

- **Trustworthy & Reliable**: Deep Google Blue (`#1A73E8`) inspires confidence for financial transactions and security gate passes.
- **Approachably Simple**: Friendly, warm, non-intimidating typography and accessible off-white backgrounds.
- **Calm & Unhurried**: Soft neutral grays with crisp borders prevent visual panic during emergency SOS alerts.

---

## 4. User Experience Goals

- **Senior Citizen Success**: A 75-year-old resident can approve a delivery boy without wearing reading glasses or seeking help.
- **Watchman Throughput**: A gate watchman can record a guest entry in under 5 seconds with zero typing lag on a ₹6,000 Android phone.
- **Zero Accidental Taps**: Crucial actions (SOS panic trigger, denying visitor entry) require explicit, deliberate interaction states.

---

## 5. Visual Language

Built upon **Material Design 3 (Material You)** defaults, heavily optimized for high-contrast light mode with clean borders, flat cards, and prominent status chips.

- **Canvas Background**: Light warm gray (`#F8F9FA`) to reduce eye glare compared to harsh pure white.
- **Borders & Outlines**: Explicit 1dp subtle slate borders (`#C7C5D0`) around all input fields and cards to clearly define touch boundaries.
- **Surface Layering**: Elevation is conveyed through clean borders and subtle tonal contrast rather than heavy drop shadows.

---

## 6. Color System

All colors are specified in 8-digit HEX (`#AARRGGBB` or `#RRGGBB`).

| Color Category | Token Name | HEX Code | Usage & Application Guidelines |
| :--- | :--- | :--- | :--- |
| **Primary** | `kColorPrimary` | `#1A73E8` | Primary active buttons, selected tabs, active bottom nav items, links. |
| **Primary Container**| `kColorPrimaryContainer` | `#E8F0FE` | Background for active chips, highlighted list items, selected card fills. |
| **Secondary** | `kColorSecondary` | `#5F6368` | Subtitles, secondary icons, inactive step indicators. |
| **Success** | `kColorSuccess` | `#188038` | "Approve" button, Entry status `INSIDE`, Paid bill status, Positive toast. |
| **Success Container**| `kColorSuccessContainer` | `#E6F4EA` | Success banner background, `APPROVED` status chip fill. |
| **Warning** | `kColorWarning` | `#E37400` | `PENDING` visitor approval, Due maintenance bill notice, Caution alerts. |
| **Warning Container**| `kColorWarningContainer` | `#FEF7E0` | Pending badge fill, caution snackbar background. |
| **Error / SOS** | `kColorError` | `#D93025` | "Deny" button, Gate Emergency SOS alert, Overdue bill status, Delete action. |
| **Error Container** | `kColorErrorContainer` | `#FCE8E6` | Error banner fill, `DENIED` status chip fill, invalid field border. |
| **Neutral Main** | `kColorTextPrimary` | `#1C1B1F` | Primary text headings, body text, form input text (High contrast). |
| **Neutral Sub** | `kColorTextSecondary` | `#49454F` | Captions, timestamps, secondary labels, helper text. |
| **Neutral Disabled**| `kColorTextDisabled` | `#1C1B1F` (38% Opacity) | Disabled buttons, inactive field placeholders. |
| **Background Main** | `kColorBackground` | `#F8F9FA` | Main screen scaffold background canvas. |
| **Surface Card** | `kColorSurface` | `#FFFFFF` | Card backgrounds, dialog surfaces, bottom sheet fills. |
| **Border / Outline** | `kColorOutline` | `#C7C5D0` | Card borders, text field outlines, divider lines. |

---

## 7. Dark Mode Strategy

- **Default Theme**: **Light Mode is the strict primary default**.
- **Dark Mode Policy**:
  - Dark mode is supported **only** as a system-toggle preference for night battery saving.
  - Dark Mode Canvas: `#121212` (Pure Dark Charcoal).
  - Dark Mode Surface: `#1E1E1E` (Slightly Elevated Charcoal).
  - Primary Accent in Dark Mode: Tinted lighter blue (`#8AB4F8`) to maintain 7:1 contrast ratio.
  - **Security Watchman App**: Forces High-Contrast Light Mode by default for daytime outdoor visibility.

---

## 8. Typography

Font Family: **Inter** (Google Fonts) with fallbacks to system **Roboto** (Android) and **SF Pro Text** (iOS).

### Type Scale Specification:

| Style Token | Weight | Font Size | Line Height | Letter Spacing | Usage Context |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `kTextDisplayLarge` | Bold (700) | 28 sp | 34 dp | -0.5 px | Emergency SOS titles, OTP numbers |
| `kTextHeadingLarge` | SemiBold (600) | 22 sp | 28 dp | 0.0 px | Top App Bar titles, Screen main titles |
| `kTextHeadingMedium` | SemiBold (600) | 18 sp | 24 dp | 0.15 px | Card titles, Flat unit numbers (`A-402`) |
| `kTextHeadingSmall` | Medium (500) | 16 sp | 22 dp | 0.15 px | List tile primary text, Form labels |
| `kTextBodyLarge` | Regular (400) | 16 sp | 24 dp | 0.5 px | Body paragraphs, Read notices |
| `kTextBodyMedium` | Regular (400) | 14 sp | 20 dp | 0.25 px | Subtitles, Field helper text |
| `kTextCaption` | Medium (500) | 12 sp | 16 dp | 0.4 px | Status chips, timestamps, badges |
| `kTextButton` | SemiBold (600) | 16 sp | 24 dp | 0.5 px | Action button text (ALWAYS sentence case) |

---

## 9. Elevation System

Elevation is controlled via Material 3 tonal elevation and strict 1dp outline borders rather than heavy drop shadows.

- **Level 0 (Flat)**: `0dp` — Scaffold background (`#F8F9FA`), Form input backgrounds.
- **Level 1 (Card Surface)**: `1dp` elevation + `1dp` border (`#C7C5D0`) — Visitor cards, Notice tiles, Flat directory items.
- **Level 2 (Navigation / FAB)**: `2dp` elevation — Sticky Bottom Navigation bar, Floating Action Buttons.
- **Level 3 (Modal / Sheet)**: `4dp` elevation — Bottom sheets, Action confirmation dialogs.
- **Level 4 (Emergency Overlay)**: `8dp` elevation — SOS full-screen alert dialogs.

---

## 10. Corner Radius System

Uniform border radii prevent visual disharmony:

- **Sharp Radius (`0dp`)**: Full-width banners, sticky bottom bars.
- **Small Radius (`4dp`)**: Status chips, small badges, inline tags.
- **Medium Radius (`8dp`)**: **Standard Card radius**, Form input fields, Dialog containers.
- **Large Radius (`16dp`)**: Bottom sheet top corners, Floating Action Buttons.
- **Pill Radius (`24dp` or `999dp`)**: Primary pill action buttons, Search bar inputs.

---

## 11. Shadow System

To maintain high performance on low-end Android GPUs:

- **Forbidden**: Blurry ambient drop shadows with `blurRadius > 8` or `spreadRadius > 2`.
- **Allowed Shadow Token**:
  ```
  BoxShadow(
    color: Color(0x0F000000), // 6% black opacity
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  )
  ```

---

## 12. Spacing System

Based strictly on an **8pt Grid System** (with a 4pt micro-step for fine alignment):

```
kSpaceXS  :  4 dp  - Micro spacing between icon & small badge
kSpaceS   :  8 dp  - Padding inside chips, vertical space between list items
kSpaceM   : 16 dp  - Standard screen edge margin, card internal padding
kSpaceL   : 24 dp  - Vertical spacing between independent card sections
kSpaceXL  : 32 dp  - Header top spacing, modal top clearance
kSpaceXXL : 48 dp  - Large touch target height boundary
```

### Justification:
The 8pt grid guarantees mathematical alignment across all Android device density screens (mdpi, hdpi, xhdpi, xxhdpi).

---

## 13. Layout Rules

- **Screen Margins**: Always `16dp` padding on left and right screen edges for mobile screens.
- **Vertical Rhythm**: Related elements grouped with `8dp` space; unrelated sections separated by `24dp` space.
- **Single Scroll View**: Screens with forms must be wrapped in `SingleChildScrollView` to prevent keyboard overflow crashes (`AAB Pixel Overflow`).

---

## 14. Responsive Rules

- **Compact Devices (< 360dp width)**: Font sizes automatically step down by 1sp; action buttons stack vertically instead of side-by-side.
- **Standard Phones (360dp - 599dp width)**: Single column layout; full-width bottom action sheets.
- **Tablets / Foldables (>= 600dp width)**: Dual-pane master-detail split layout (e.g. Left pane: Visitor list, Right pane: Selected visitor log details).

---

## 15. Safe Area Rules

- **Top Safe Area**: Respect notch and camera cutouts using Flutter `SafeArea(top: true)`.
- **Bottom Safe Area**: Bottom sticky action buttons must extend background color into the home indicator gesture bar, but internal tap target padding must be elevated above `MediaQuery.of(context).padding.bottom + 8dp`.

---

## 16. Component Library

### 16.1 Buttons
- **Primary Button**: Solid fill (`#1A73E8`), white text, 48dp height, 8dp/24dp radius, bold centered text.
- **Secondary Button**: Outlined border (`1dp #1A73E8`), blue text, transparent background.
- **Destructive Button**: Solid fill (`#D93025`), white text (Used for SOS and Deny actions).
- **Text Button**: Borderless, blue/gray text, 48dp minimum touch target.

### 16.2 Cards
- Surface color `#FFFFFF`, border `1dp #C7C5D0`, radius `8dp`, internal padding `16dp`.

### 16.3 Input Fields
- Outlined text fields with explicit floating label, `8dp` radius, helper text beneath field. Error states turn border to `#D93025` with explicit error message icon.

### 16.4 Dropdowns
- Material 3 modal bottom sheet picker on mobile instead of inline native dropdowns to accommodate large finger taps.

### 16.5 Search Bars
- Full width, pill-shaped (`24dp` radius), background `#F1F3F4`, leading search icon, trailing clear `(X)` button when non-empty.

### 16.6 Bottom Sheets
- Rounded top corners (`16dp`), top drag handle pill (`4dp x 32dp #C7C5D0`), max height 85% screen height.

### 16.7 Dialogs
- Centered, `16dp` radius, maximum 2 action buttons at bottom ("Cancel" left, "Confirm" right).

### 16.8 Snackbars
- Floating at bottom above nav bar, dark background `#322F35`, white text, optional single text button action ("UNDO"). Auto-dismiss in 4 seconds.

### 16.9 Switches & Checkboxes
- Minimum 48x48 dp touch container around the switch handle. High contrast active track `#1A73E8`.

### 16.10 Chips & Badges
- Status chips: `APPROVED` (Green fill `#E6F4EA`, Green text `#188038`), `PENDING` (Amber fill `#FEF7E0`, Amber text `#E37400`), `DENIED` (Red fill `#FCE8E6`, Red text `#D93025`).

### 16.11 Progress Indicators
- Linear progress bar for file/photo uploads (`4dp` height). Circular progress indicator (`24dp` size, `3dp` stroke) for button inline loading states.

### 16.12 Floating Action Button (FAB)
- Extended FAB with icon + text label (e.g. `[+] Pre-Approve Guest`), `16dp` corner radius, anchored at bottom right.

### 16.13 Bottom Navigation
- Fixed 4 or 5 items maximum (`Home`, `Services`, `Notices`, `Profile`). Active icon has rounded primary container pill indicator (`#E8F0FE`).

### 16.14 List Tiles
- Leading icon/avatar (`40dp`), Title (16sp), Subtitle (14sp), Trailing chevron or status badge. Minimum height `64dp`.

### 16.15 Avatar
- CircleAvatar with initials if image unavailable. High contrast text on `#E8F0FE` background.

### 16.16 Skeleton Loading
- Subtle pulsing gray boxes (`#E1E3E1` to `#F1F3F4`) matching exact shape of destination text and cards. NO spinning loaders covering full screen.

---

## 17. Iconography

- **Library**: **Material Symbols Outlined** (2dp stroke width).
- **Rule**: Every icon MUST be accompanied by a text label, except in standard bottom navigation bars.
- **Sizes**:
  - Inline / Subtitle Icon: `18dp`
  - Body / Action Icon: `24dp`
  - Large Header / Status Icon: `36dp` - `48dp`

---

## 18. Illustration Style

- **Style**: Simple, flat vector illustrations with solid color fills (Google / PhonePe style).
- **Palette**: Uses primary brand colors (`#1A73E8`, `#E8F0FE`, `#5F6368`).
- **Context**: Used strictly on Empty States, Success Completion screens, and Auth Onboarding.
- **Forbidden**: Detailed 3D renders, isometric complex cityscapes, or hand-drawn noisy doodles.

---

## 19. Image Guidelines

- **Visitor Photos**: Captured at gate by watchman; displayed as `48x48 dp` rounded avatar (`8dp` radius) in visitor log cards.
- **Compression**: Images compressed on client-side to max `1024x1024` resolution, JPEG format, quality 75% before upload.
- **Aspect Ratio**: Standard 16:9 for notice board image attachments; 1:1 square for visitor/resident profile photos.

---

## 20. Animation Guidelines

- **Allowed Animations**:
  - Page transitions: Standard Material 3 Shared Axis (Horizontal for forward navigation).
  - List expansion: Smooth height transition (150ms).
  - Button touch feedback: Instant ink splash/ripple (16ms).
- **Forbidden Animations**:
  - ❌ NO Lottie animations longer than 1.5 seconds.
  - ❌ NO Continuous looping background animations.
  - ❌ NO Skeuomorphic card flipping or 3D rotations.
- **Duration Token**: `kDurationFast = 150ms`, `kDurationNormal = 250ms`.
- **Easing Curve**: `Curves.easeInOutCubic`.

---

## 21. Accessibility

- **Touch Targets**: Minimum **48x48 dp** for every clickable element (enforced via Flutter `IconButton(constraints: BoxConstraints(minWidth: 48, minHeight: 48))`).
- **Contrast Ratios**: Body text on canvas must satisfy **WCAG 2.1 AAA (minimum 7:1)**.
- **Text Scaling**: Tested up to **2.0x system dynamic text scaling** without overflow or clipping.
- **Screen Readers**: All image avatars must have `semanticsLabel` (e.g. `"Visitor photo of Rajesh Kumar"`).

---

## 22. Forms UX

- **Validation Timing**: On field focus loss (`unfocus`) or primary form submit press. Never validate on first character entry.
- **Error Display**: Inline red text directly below the problematic input field with an error icon.
- **Keyboard Handling**:
  - Automatic Next field focus (`TextInputAction.next`).
  - Mobile number fields trigger `TextInputType.phone` (Large numeric keypad).
  - Tap outside input field unfocuses keyboard automatically.

---

## 23. Dashboard Design Rules

- **Top Section**: Current Society Name + Resident Flat Number (`Green Park Apts • A-402`).
- **Primary Hero Card**: Active Pending Visitor Approvals (If any) or SOS Emergency Button.
- **Quick Action Grid**: 4 primary actions maximum (`Pre-Approve Guest`, `Pay Maintenance`, `Raise Complaint`, `Notice Board`).

---

## 24. Card Design Rules

- **Maximum Information Density**: No more than 4 data points per card (e.g., Name, Flat, Timestamp, Status).
- **Primary Action Positioning**: Action buttons placed at the bottom right of the card.

---

## 25. Table Design Rules

- Tables are **forbidden on mobile phone screens**.
- Data must be represented as stacked List Tiles or structured Cards. (Tables permitted only on desktop/tablet web admin dashboards).

---

## 26. List Design Rules

- Divided by subtle `1dp` outline dividers (`#E1E3E1`) or `8dp` vertical spacing gaps.
- Infinite scroll lists must show a small centered inline progress indicator at bottom when fetching next page.

---

## 27. Search Experience

- Instant local client-side filtering over Drift local database (Sub-10ms response).
- Search query matches highlighted in **bold font**.

---

## 28. Notification UX

- **Visitor Request Push Notification**:
  - Title: `Guest Arrived at Main Gate`
  - Body: `Ramesh (Delivery) is requesting entry for Flat A-402.`
  - Action Buttons on Notification: `[ APPROVE ]` (Green) | `[ DENY ]` (Red).

---

## 29. Empty State UX

- Simple flat vector illustration.
- Clear title: e.g., `"No Recent Visitors"`.
- Actionable subtext: `"When guests or deliveries arrive at the gate, they will appear here."`
- Optional primary action button: `[ Pre-Approve Guest ]`.

---

## 30. Offline Mode UX

- A thin persistent top banner appears when offline:
  `[ ⚡ Offline Mode — Gate entries will sync when reconnected ]` (Amber background `#FEF7E0`, Amber text `#E37400`).
- User can continue performing actions seamlessly without error dialog popups.

---

## 31. Error Handling UX

- Network timeouts show a clean full-screen retry state:
  - Icon: Cloud Off (`wifi_off`).
  - Heading: `"Unable to Connect"`.
  - Subtext: `"Please check your internet connection and try again."`
  - Button: `[ Tap to Retry ]`.

---

## 32. Loading UX

- Primary loading state: **Shimmer / Skeleton Cards** matching exact layout of list items.
- Full-screen blocking spinners are strictly prohibited except during critical Payment Processing.

---

## 33. Success UX

- Full-width success sheet or screen with a large green checkmark circle (`#188038`), bold success message, and single button `[ Done ]`.
- Auto-triggers subtle haptic feedback (`HapticFeedback.lightImpact()`).

---

## 34. Navigation Guidelines

- **Bottom Navigation**: Used for switching primary domains (`Home`, `Services`, `Notices`, `Profile`).
- **Back Navigation**: Top-left explicit back arrow (`arrow_back`) with label on secondary screens.
- **Modal Sheets**: Used for short task completions (Pre-approving guest, paying bill).

---

## 35. Role Based UI Differences

```
┌────────────────────────────────────────────────────────────────────────┐
│                          NIVAAS ROLE UI RULES                          │
├──────────────────┬──────────────────┬──────────────────────────────────┤
│ RESIDENT ROLE    │ WATCHMAN ROLE    │ SOCIETY ADMIN ROLE               │
├──────────────────┼──────────────────┼──────────────────────────────────┤
│ - Light Theme    │ - High Contrast  │ - Detailed Lists & Status Filters│
│ - Bottom Nav     │ - Single Stream  │ - Member Approval Queue Cards    │
│ - Pre-Approval   │ - 4 Large Buttons│ - Broadcast Announcement Creator │
│ - Billing Cards  │ - Quick OTP Scan │ - Outstanding Dues Ledger Table  │
└──────────────────┴──────────────────┴──────────────────────────────────┘
```

---

## 36. Design Tokens

Dart Token Mapping reference:

```dart
class NivaasColors {
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryContainer = Color(0xFFE8F0FE);
  static const Color success = Color(0xFF188038);
  static const Color successContainer = Color(0xFFE6F4EA);
  static const Color error = Color(0xFFD93025);
  static const Color errorContainer = Color(0xFFFCE8E6);
  static const Color warning = Color(0xFFE37400);
  static const Color warningContainer = Color(0xFFFEF7E0);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFC7C5D0);
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
}

class NivaasSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double touchTarget = 48.0;
}

class NivaasRadii {
  static const double s = 4.0;
  static const double m = 8.0;
  static const double l = 16.0;
  static const double pill = 24.0;
}
```

---

## 37. Naming Convention

- Component Widgets: `Nivaas<ComponentName>` (e.g., `NivaasPrimaryButton`, `NivaasVisitorCard`, `NivaasStatusChip`).
- Style Tokens: `k<Category><Name>` (e.g., `kTextHeadingLarge`, `kColorPrimary`, `kSpaceM`).

---

## 38. Flutter Widget Recommendations

- Prefer `SizedBox` over `Container` for empty spacing.
- Prefer `ListView.builder` over `SingleChildScrollView + Column` for long dynamic lists.
- Wrap tap handlers in `InkWell` (inside Material) or `GestureDetector` with explicit `HitTestBehavior.opaque` to ensure full 48dp touch region responsiveness.

---

## 39. UI Do's

- ✅ **DO** pair every icon with a text label.
- ✅ **DO** use sentence case for all button labels (`Pre-approve guest`, not `PRE-APPROVE GUEST`).
- ✅ **DO** test screens with 2.0x dynamic font scaling turned on in Android Settings.
- ✅ **DO** provide immediate haptic and visual feedback on button taps.
- ✅ **DO** keep background colors warm off-white (`#F8F9FA`) for comfortable long reading.

---

## 40. UI Don'ts

- ❌ **DON'T** use glassmorphism, neumorphism, or heavy drop shadows.
- ❌ **DON'T** put single action buttons at the top right of mobile screens out of thumb reach.
- ❌ **DON'T** rely on color alone to convey status (Always pair colors with explicit status text like `APPROVED` or `DENIED`).
- ❌ **DON'T** show modal popups for routine non-critical updates.
- ❌ **DON'T** hide essential actions inside hamburger side menus if they belong in bottom navigation.

---

## 41. Future Design Expansion

- **Multi-Language Regional UI**: Infrastructure supports dynamic String localization (Hindi, Marathi, Tamil, Telugu, Kannada) with right-to-left and script height line-height adjustments.
- **Voice-Assisted Gate Lookups**: Watchman interface will accommodate a single tap microphone button for voice-based flat number query (`"A 402"`).

---

## 42. Final Summary

The **Nivaas Design System** prioritizes **clarity, speed, accessibility, and utility** above visual ornamentation.

By strictly enforcing high contrast ratios, generous 48dp touch targets, simple 8pt spacing grid, clean Material 3 component primitives, and familiar Google Pay/WhatsApp design patterns, Nivaas ensures an effortless experience for all users across India—from tech-savvy youth to senior citizens and gate security guards.
