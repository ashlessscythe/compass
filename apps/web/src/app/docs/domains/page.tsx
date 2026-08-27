import Link from "next/link";
import { listDomainPacks } from "@compass/domains";

import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { PackInstallUrl } from "@/components/domains/pack-install-url";

export default function DomainsDocsPage() {
  const packs = listDomainPacks();

  return (
    <>
      <SiteHeader />
      <main id="main" className="mx-auto max-w-3xl px-6 pb-24 pt-28">
        <h1 className="font-display text-3xl font-semibold tracking-tight md:text-4xl">
          Domain packs
        </h1>
        <p className="mt-4 text-muted-foreground">
          Compass verticals ship as versioned domain packs — asset types,
          attribute schemas, CSV import/export dialects, and catalog providers.
          Packs are JSON manifests served from this site and bundled in the mobile
          app for offline use.
        </p>
        <ul className="mt-10 space-y-4">
          {packs.map((pack) => (
            <li key={pack.id}>
              <div className="rounded-xl border border-white/10 bg-white/[0.02] p-5 transition-colors hover:border-primary/40 hover:bg-white/[0.04]">
                <Link href={`/docs/domains/${pack.id}`} className="block">
                  <div className="flex items-baseline justify-between gap-4">
                    <h2 className="font-display text-xl font-medium">
                      {pack.displayName}
                    </h2>
                    <span className="text-sm text-muted-foreground">
                      v{pack.version}
                    </span>
                  </div>
                  <p className="mt-2 text-sm text-muted-foreground">
                    {pack.description}
                  </p>
                </Link>
                <PackInstallUrl packId={pack.id} compact />
              </div>
            </li>
          ))}
        </ul>
        <p className="mt-10 text-sm text-muted-foreground">
          JSON API:{" "}
          <Link href="/api/domains" className="text-primary hover:underline">
            /api/domains
          </Link>
        </p>
      </main>
      <SiteFooter />
    </>
  );
}
