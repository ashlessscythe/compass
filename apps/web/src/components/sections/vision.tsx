"use client";

import {
  Camera,
  Cpu,
  FileText,
  Gem,
  Home,
  Layers,
  Shirt,
  Cuboid,
  Trophy,
  Watch,
  Wrench,
  type LucideIcon,
} from "lucide-react";
import { siteCopy } from "@compass/branding";
import { FadeIn } from "@/components/motion/fade-in";

const moduleIcons: Record<string, LucideIcon> = {
  cards: Layers,
  tools: Wrench,
  jewelry: Gem,
  watches: Watch,
  clothing: Shirt,
  lego: Cuboid,
  electronics: Cpu,
  home: Home,
  documents: FileText,
  camera: Camera,
  collectibles: Trophy,
};

function ModuleCard({
  id,
  label,
}: {
  id: string;
  label: string;
}) {
  const Icon = moduleIcons[id] ?? Layers;

  return (
    <article className="group glass relative flex w-[11.5rem] shrink-0 flex-col items-center gap-4 overflow-hidden rounded-2xl px-5 py-7 sm:w-[13rem] sm:px-6 sm:py-8">
      <div
        aria-hidden
        className="pointer-events-none absolute inset-x-0 top-0 h-24 bg-gradient-to-b from-primary/10 to-transparent opacity-80 transition-opacity duration-500 group-hover:opacity-100"
      />
      <div className="relative inline-flex size-14 items-center justify-center rounded-2xl border border-white/10 bg-white/[0.04] text-primary transition-transform duration-500 group-hover:scale-110 sm:size-16">
        <Icon className="size-7 sm:size-8" strokeWidth={1.5} aria-hidden />
      </div>
      <h3 className="relative font-display text-base font-semibold tracking-tight text-foreground/90 sm:text-lg">
        {label}
      </h3>
    </article>
  );
}

export function Vision() {
  const items = siteCopy.vision.items;
  // Duplicate for a seamless infinite marquee loop.
  const track = [...items, ...items];

  return (
    <section
      id="vision"
      className="relative overflow-hidden py-20 md:py-28"
      aria-labelledby="vision-heading"
    >
      <div
        aria-hidden
        className="pointer-events-none absolute inset-x-0 top-1/2 -z-10 h-48 -translate-y-1/2 bg-primary/[0.04] blur-3xl"
      />

      <div className="mx-auto mb-12 max-w-6xl px-6 md:mb-16">
        <FadeIn className="mx-auto max-w-2xl text-center">
          <h2
            id="vision-heading"
            className="font-display text-3xl font-semibold tracking-tight sm:text-4xl md:text-5xl"
          >
            {siteCopy.vision.title}
          </h2>
          <p className="mt-4 text-lg text-muted-foreground">
            {siteCopy.vision.subtitle}
          </p>
        </FadeIn>
      </div>

      <FadeIn delay={0.12}>
        <div
          className="relative"
          role="region"
          aria-roledescription="carousel"
          aria-label="Future inventory modules"
        >
          <div
            aria-hidden
            className="pointer-events-none absolute inset-y-0 left-0 z-10 w-12 bg-gradient-to-r from-background to-transparent sm:w-24"
          />
          <div
            aria-hidden
            className="pointer-events-none absolute inset-y-0 right-0 z-10 w-12 bg-gradient-to-l from-background to-transparent sm:w-24"
          />

          <div className="overflow-hidden motion-reduce:hidden">
            <ul className="flex w-max animate-marquee gap-4 py-2 pl-6 hover:[animation-play-state:paused] focus-within:[animation-play-state:paused] sm:gap-5">
              {track.map((item, index) => {
                const isDuplicate = index >= items.length;

                return (
                  <li
                    key={`${item.id}-${index}`}
                    aria-hidden={isDuplicate || undefined}
                  >
                    <ModuleCard id={item.id} label={item.label} />
                  </li>
                );
              })}
            </ul>
          </div>

          {/* Static fallback for reduced-motion users */}
          <ul className="mx-auto hidden max-w-6xl flex-wrap justify-center gap-4 px-6 motion-reduce:flex">
            {items.map((item) => (
              <li key={item.id}>
                <ModuleCard id={item.id} label={item.label} />
              </li>
            ))}
          </ul>
        </div>
      </FadeIn>
    </section>
  );
}
