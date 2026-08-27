import Link from "next/link";
import { CompassMark } from "@compass/ui";
import { siteCopy } from "@compass/branding";
import { siteConfig } from "@/lib/site";

export function SiteFooter() {
  return (
    <footer className="border-t border-white/5">
      <div className="mx-auto flex max-w-6xl flex-col gap-6 px-6 py-12 md:flex-row md:items-center md:justify-between">
        <div className="flex items-center gap-2.5">
          <CompassMark className="size-5 text-primary" />
          <span className="font-display text-sm font-medium tracking-tight">
            {siteCopy.brand.name}
          </span>
          <span className="text-muted-foreground">·</span>
          <span className="text-sm text-muted-foreground">{siteCopy.brand.tagline}</span>
        </div>
        <div className="flex flex-wrap items-center gap-4 text-sm text-muted-foreground">
          <Link href="/docs/domains" className="transition-colors hover:text-foreground">
            Domains
          </Link>
          <Link href="/privacy" className="transition-colors hover:text-foreground">
            Privacy
          </Link>
          <a
            href={siteConfig.github}
            target="_blank"
            rel="noopener noreferrer"
            className="transition-colors hover:text-foreground"
          >
            GitHub
          </a>
          <span>{siteCopy.footer.rights}</span>
        </div>
      </div>
    </footer>
  );
}
