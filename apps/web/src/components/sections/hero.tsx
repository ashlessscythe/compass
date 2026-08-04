"use client";

import Link from "next/link";
import { motion, useScroll, useTransform } from "framer-motion";
import { Github, ArrowRight } from "lucide-react";
import { CompassMark } from "@compass/ui";
import { siteCopy } from "@compass/branding";
import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/site";
import { useRef } from "react";

export function Hero() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start start", "end start"],
  });
  const y = useTransform(scrollYProgress, [0, 1], [0, 120]);
  const opacity = useTransform(scrollYProgress, [0, 0.85], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 1], [1, 0.96]);
  const blur = useTransform(scrollYProgress, [0, 1], [0, 6]);
  const filter = useTransform(blur, (value) => `blur(${value}px)`);

  return (
    <section
      ref={ref}
      className="relative flex min-h-[100svh] items-center justify-center overflow-hidden px-6 pb-20 pt-28"
      aria-labelledby="hero-heading"
    >
      <div
        aria-hidden
        className="pointer-events-none absolute inset-0 -z-10"
      >
        <div className="absolute left-1/2 top-1/4 h-[520px] w-[520px] -translate-x-1/2 rounded-full bg-primary/20 blur-[120px] animate-gradient-shift" />
        <div className="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.03)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.03)_1px,transparent_1px)] bg-[size:64px_64px] [mask-image:radial-gradient(ellipse_at_center,black_20%,transparent_70%)]" />
      </div>

      <motion.div
        style={{ y, opacity, scale, filter }}
        className="relative mx-auto flex w-full max-w-4xl flex-col items-center text-center"
      >
        <motion.div
          initial={{ opacity: 0, scale: 0.9, filter: "blur(10px)" }}
          animate={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
          transition={{ duration: 0.9, ease: [0.22, 1, 0.36, 1] }}
          className="mb-8 flex flex-col items-center gap-5"
        >
          <CompassMark className="size-16 text-primary md:size-20 animate-float" />
          <h1 className="font-display text-5xl font-semibold tracking-tight text-foreground sm:text-6xl md:text-7xl lg:text-8xl">
            {siteCopy.brand.name}
          </h1>
        </motion.div>

        <motion.p
          id="hero-heading"
          initial={{ opacity: 0, y: 20, filter: "blur(8px)" }}
          animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
          transition={{ duration: 0.8, delay: 0.15, ease: [0.22, 1, 0.36, 1] }}
          className="font-display text-balance text-2xl font-medium tracking-tight text-foreground/95 sm:text-3xl md:text-4xl"
        >
          {siteCopy.hero.headline}
        </motion.p>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.28, ease: [0.22, 1, 0.36, 1] }}
          className="mt-6 max-w-2xl text-balance text-base text-muted-foreground sm:text-lg md:text-xl"
        >
          {siteCopy.hero.subheadline}
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.42, ease: [0.22, 1, 0.36, 1] }}
          className="mt-10 flex flex-col items-center gap-3 sm:flex-row"
        >
          <Button asChild size="lg" className="min-w-[200px]">
            <a href="#waitlist">
              {siteCopy.hero.primaryCta}
              <ArrowRight className="size-4" />
            </a>
          </Button>
          <Button asChild variant="outline" size="lg" className="min-w-[160px]">
            <Link
              href={siteConfig.github}
              target="_blank"
              rel="noopener noreferrer"
            >
              <Github className="size-4" />
              {siteCopy.hero.secondaryCta}
            </Link>
          </Button>
        </motion.div>
      </motion.div>
    </section>
  );
}
