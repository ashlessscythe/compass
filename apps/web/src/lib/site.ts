import { brand } from "@compass/branding";

export const siteConfig = {
  name: brand.name,
  tagline: brand.tagline,
  description:
    "Compass is an offline-first asset management platform that maps your digital inventory to real-world locations.",
  url: process.env.NEXT_PUBLIC_SITE_URL ?? `https://${brand.domain}`,
  github: brand.github,
  locale: "en_US",
  twitterHandle: "@getcompass",
} as const;
