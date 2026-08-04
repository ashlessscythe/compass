/**
 * Compass design tokens.
 * Dark-first palette with cool steel accents — premium software, not fantasy.
 */
export const brand = {
  name: "Compass",
  tagline: "Know where everything is.",
  domain: "getcompass.space",
  github: "https://github.com/ashlessscythe/compass",
} as const;

export const colors = {
  background: {
    DEFAULT: "#0A0B0D",
    elevated: "#12141A",
    muted: "#1A1D26",
  },
  foreground: {
    DEFAULT: "#F4F5F7",
    muted: "#9AA3B2",
    subtle: "#6B7385",
  },
  accent: {
    DEFAULT: "#5B8DEF",
    soft: "#7AA2F7",
    deep: "#3B6FD4",
    glow: "rgba(91, 141, 239, 0.35)",
  },
  border: {
    DEFAULT: "rgba(255, 255, 255, 0.08)",
    strong: "rgba(255, 255, 255, 0.14)",
  },
  success: "#3DDC97",
  warning: "#F5A524",
  danger: "#F31260",
} as const;

export const typography = {
  display: "Space Grotesk",
  sans: "Geist",
  body: "Inter",
} as const;

export const radii = {
  sm: "0.375rem",
  md: "0.75rem",
  lg: "1rem",
  xl: "1.5rem",
} as const;

export const modules = [
  "Magic: The Gathering",
  "Tools",
  "Jewelry",
  "Watches",
  "Clothing",
  "LEGO",
  "Electronics",
  "Home Inventory",
  "Documents",
  "Camera Equipment",
  "Collectibles",
] as const;

export type BrandModule = (typeof modules)[number];
