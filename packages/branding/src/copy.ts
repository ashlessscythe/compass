import { brand } from "./tokens";

export const siteCopy = {
  brand,
  hero: {
    headline: "Know where everything is.",
    subheadline:
      "Compass is an offline-first asset management platform that maps your digital inventory to real-world locations.",
    primaryCta: "Join the Waitlist",
    secondaryCta: "GitHub",
  },
  features: [
    {
      id: "offline-first",
      title: "Offline First",
      description: "Everything works without internet.",
    },
    {
      id: "nfc-powered",
      title: "NFC Powered",
      description: "Tap a container and instantly open it.",
    },
    {
      id: "find-anything",
      title: "Find Anything",
      description: "Search any item and see exactly where it lives.",
    },
    {
      id: "universal",
      title: "Universal",
      description: "Cards today. Everything tomorrow.",
    },
    {
      id: "import",
      title: "Import Existing Collections",
      description: "Import from Deckbox, Moxfield, CSV, and more.",
    },
  ],
  vision: {
    title: "Future Vision",
    items: [
      "Cards",
      "Tools",
      "Jewelry",
      "Electronics",
      "Home Inventory",
      "Collectibles",
    ],
  },
  waitlist: {
    title: "Be first when Compass launches.",
    description:
      "Join the waitlist for early access. Built for collectors who care where things live.",
    success: "You're on the list. We'll be in touch.",
    placeholder: "you@email.com",
    submit: "Join Waitlist",
  },
  footer: {
    rights: `© ${new Date().getFullYear()} Compass. All rights reserved.`,
  },
} as const;
