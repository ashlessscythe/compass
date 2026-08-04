"use client";

import { siteCopy } from "@compass/branding";
import { FadeIn } from "@/components/motion/fade-in";

export function Vision() {
  return (
    <section
      id="vision"
      className="relative px-6 py-24 md:py-32"
      aria-labelledby="vision-heading"
    >
      <div className="mx-auto max-w-6xl">
        <FadeIn className="mx-auto mb-14 max-w-2xl text-center">
          <h2
            id="vision-heading"
            className="font-display text-3xl font-semibold tracking-tight sm:text-4xl md:text-5xl"
          >
            {siteCopy.vision.title}
          </h2>
          <p className="mt-4 text-lg text-muted-foreground">
            Cards today. Everything tomorrow.
          </p>
        </FadeIn>

        <FadeIn delay={0.1}>
          <ul className="mx-auto flex max-w-4xl flex-wrap items-center justify-center gap-3 md:gap-4">
            {siteCopy.vision.items.map((item, index) => (
              <li key={item}>
                <FadeIn delay={0.05 * index}>
                  <span className="inline-flex items-center rounded-full border border-white/10 bg-white/[0.03] px-5 py-2.5 font-display text-sm font-medium tracking-tight text-foreground/90 transition-all duration-300 hover:border-primary/40 hover:bg-primary/10 hover:text-foreground md:text-base">
                    {item}
                  </span>
                </FadeIn>
              </li>
            ))}
          </ul>
        </FadeIn>
      </div>
    </section>
  );
}
