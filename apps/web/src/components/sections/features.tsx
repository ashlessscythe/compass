"use client";

import {
  WifiOff,
  Nfc,
  Search,
  Layers,
  Upload,
  type LucideIcon,
} from "lucide-react";
import { siteCopy } from "@compass/branding";
import { FadeIn } from "@/components/motion/fade-in";

const icons: Record<string, LucideIcon> = {
  "offline-first": WifiOff,
  "nfc-powered": Nfc,
  "find-anything": Search,
  universal: Layers,
  import: Upload,
};

export function Features() {
  return (
    <section
      id="features"
      className="relative px-6 py-24 md:py-32"
      aria-labelledby="features-heading"
    >
      <div className="mx-auto max-w-6xl">
        <FadeIn className="mx-auto mb-16 max-w-2xl text-center md:mb-20">
          <h2
            id="features-heading"
            className="font-display text-3xl font-semibold tracking-tight sm:text-4xl md:text-5xl"
          >
            Built for where things live
          </h2>
          <p className="mt-4 text-lg text-muted-foreground">
            Inventory that answers the question that actually matters.
          </p>
        </FadeIn>

        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {siteCopy.features.map((feature, index) => {
            const Icon = icons[feature.id] ?? Layers;
            const wide = feature.id === "import";

            return (
              <FadeIn
                key={feature.id}
                delay={index * 0.08}
                blur
                className={wide ? "sm:col-span-2 lg:col-span-1" : undefined}
              >
                <article className="group glass relative h-full overflow-hidden rounded-2xl p-7 transition-all duration-500 hover:border-primary/30 hover:bg-white/[0.05]">
                  <div
                    aria-hidden
                    className="pointer-events-none absolute -right-8 -top-8 size-32 rounded-full bg-primary/10 blur-2xl transition-opacity duration-500 group-hover:opacity-100 opacity-60"
                  />
                  <div className="relative">
                    <div className="mb-5 inline-flex size-11 items-center justify-center rounded-xl border border-white/10 bg-white/[0.04] text-primary transition-transform duration-500 group-hover:scale-110">
                      <Icon className="size-5" aria-hidden />
                    </div>
                    <h3 className="font-display text-xl font-semibold tracking-tight">
                      {feature.title}
                    </h3>
                    <p className="mt-2 text-muted-foreground">{feature.description}</p>
                  </div>
                </article>
              </FadeIn>
            );
          })}
        </div>
      </div>
    </section>
  );
}
