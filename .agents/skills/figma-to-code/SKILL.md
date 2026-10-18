---
name: figma-to-code
description: "Converts design screenshots, Figma descriptions, or UI mockups into pixel-perfect, responsive, animated code. Includes animation choreography, responsive audit, and design system extraction."
---

# Figma-to-Code & Advanced UI Engine

## Trigger Conditions
- User provides a screenshot or image of a design
- User describes a UI they want built
- User asks to "convert design to code", "make it pixel-perfect"
- User asks about animations, transitions, or responsive behavior

## Protocol 1: Design → Code Translation

### Step 1: Analyze the Design
When given an image or description:
1. **Layout**: Identify the grid system (flex, grid, columns)
2. **Typography**: Extract font families, sizes, weights, line-heights
3. **Colors**: Extract the color palette (primary, secondary, accent, neutral)
4. **Spacing**: Identify the spacing scale (4px, 8px, 16px, 24px, 32px, 48px, 64px)
5. **Components**: List all reusable components
6. **States**: Identify hover, active, disabled, loading states
7. **Breakpoints**: Determine responsive behavior

### Step 2: Design Token Extraction
```css
:root {
  /* Colors */
  --color-primary: ;
  --color-secondary: ;
  --color-accent: ;
  --color-bg: ;
  --color-surface: ;
  --color-text: ;
  --color-text-muted: ;
  --color-border: ;
  --color-error: ;
  --color-success: ;

  /* Typography */
  --font-sans: ;
  --font-mono: ;
  --font-display: ;

  /* Spacing */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;
  --space-2xl: 48px;
  --space-3xl: 64px;

  /* Radii */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 16px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
  --shadow-xl: 0 20px 25px rgba(0,0,0,0.15);
}
```

### Step 3: Build Component-First
1. Start with the smallest reusable components (buttons, inputs, badges)
2. Compose into larger sections (cards, headers, sidebars)
3. Assemble into full pages
4. Each component must be self-contained and responsive

## Protocol 2: Animation Choreography

### Animation Principles
1. **Purpose**: Every animation must serve a purpose (guide attention, show state change, delight)
2. **Duration**: Micro-interactions 150-300ms, page transitions 300-500ms
3. **Easing**: Use `cubic-bezier(0.4, 0, 0.2, 1)` as default (Material Design standard)
4. **Stagger**: Stagger list items by 50-100ms for visual flow
5. **Reduce Motion**: Always respect `prefers-reduced-motion`

### Standard Animation Library
```css
/* Entrance Animations */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
@keyframes slideIn { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }
@keyframes scaleIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }

/* Interaction Animations */
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
@keyframes spin { to { transform: rotate(360deg); } }
@keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }

/* Motion Preference */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

## Protocol 3: Responsive Audit Checklist
- [ ] Mobile-first CSS (min-width breakpoints)
- [ ] Touch targets ≥44x44px on mobile
- [ ] Text readable without zooming (≥16px body)
- [ ] No horizontal scroll at any breakpoint
- [ ] Images responsive with proper aspect ratios
- [ ] Navigation adapts (hamburger menu on mobile)
- [ ] Forms usable on mobile (proper input types)
- [ ] Tables scroll horizontally or stack on mobile
- [ ] Modals/dialogs fit mobile viewport
- [ ] Tested at: 320px, 375px, 768px, 1024px, 1440px, 1920px
