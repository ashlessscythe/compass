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
          <ul className="mx-auto grid max-w-3xl grid-cols-2 gap-x-8 gap-y-5 sm:grid-cols-3">
            {siteCopy.vision.items.map((item, index) => (
              <li key={item}>
                <FadeIn delay={0.05 * index}>
                  <span className="group flex items-baseline gap-3 font-display text-lg tracking-tight text-foreground/85 transition-colors duration-300 hover:text-foreground md:text-xl">
                    <span
                      aria-hidden
                      className="inline-block size-1.5 shrink-0 rounded-full bg-primary/70 transition-transform duration-300 group-hover:scale-125"
                    />
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
