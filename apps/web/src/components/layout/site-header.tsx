"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { CompassMark } from "@compass/ui";
import { brand } from "@compass/branding";
import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/site";

export function SiteHeader() {
  return (
    <motion.header
      initial={{ opacity: 0, y: -12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1] }}
      className="fixed inset-x-0 top-0 z-50"
    >
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6 md:h-20">
        <Link
          href="/"
          className="group flex items-center gap-2.5 text-foreground transition-opacity hover:opacity-90"
          aria-label={`${brand.name} home`}
        >
          <CompassMark className="size-7 text-primary transition-transform duration-500 group-hover:rotate-45" />
          <span className="font-display text-lg font-semibold tracking-tight md:text-xl">
            {brand.name}
          </span>
        </Link>

        <nav className="flex items-center gap-2 sm:gap-3" aria-label="Primary">
          <Button asChild variant="ghost" size="sm" className="hidden sm:inline-flex">
            <Link href="/#features">Features</Link>
          </Button>
          <Button asChild variant="ghost" size="sm" className="hidden sm:inline-flex">
            <Link href="/#vision">Vision</Link>
          </Button>
          <Button asChild variant="ghost" size="sm" className="hidden sm:inline-flex">
            <Link href="/docs/domains">Domains</Link>
          </Button>
          <Button asChild variant="outline" size="sm">
            <a
              href={siteConfig.github}
              target="_blank"
              rel="noopener noreferrer"
            >
              GitHub
            </a>
          </Button>
          <Button asChild size="sm">
            <Link href="/#waitlist">Join Waitlist</Link>
          </Button>
        </nav>
      </div>
    </motion.header>
  );
}
