"use client";

import { useState } from "react";
import { Check, Copy } from "lucide-react";

import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/site";

type PackInstallUrlProps = {
  packId: string;
  compact?: boolean;
};

export function PackInstallUrl({ packId, compact = false }: PackInstallUrlProps) {
  const installUrl = `${siteConfig.url}/api/domains/${packId}`;
  const [copied, setCopied] = useState(false);

  async function copyUrl() {
    try {
      await navigator.clipboard.writeText(installUrl);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 2000);
    } catch {
      setCopied(false);
    }
  }

  if (compact) {
    return (
      <div className="mt-3 flex flex-wrap items-center gap-2">
        <code className="max-w-full truncate rounded-md bg-white/5 px-2 py-1 text-xs text-muted-foreground">
          {installUrl}
        </code>
        <Button type="button" variant="outline" size="sm" onClick={copyUrl}>
          {copied ? (
            <>
              <Check className="size-3.5" />
              Copied
            </>
          ) : (
            <>
              <Copy className="size-3.5" />
              Copy install URL
            </>
          )}
        </Button>
      </div>
    );
  }

  return (
    <section className="mt-8 rounded-xl border border-primary/25 bg-primary/5 p-5">
      <h2 className="font-display text-lg font-medium">Install in Compass</h2>
      <p className="mt-2 text-sm text-muted-foreground">
        Copy this URL, then paste it in{" "}
        <span className="text-foreground">Compass → Settings → Domain packs</span>{" "}
        to install or update this domain pack.
      </p>
      <div className="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center">
        <code className="block flex-1 break-all rounded-lg border border-white/10 bg-black/20 px-3 py-2 text-sm">
          {installUrl}
        </code>
        <Button type="button" variant="default" size="sm" onClick={copyUrl}>
          {copied ? (
            <>
              <Check />
              Copied
            </>
          ) : (
            <>
              <Copy />
              Copy URL
            </>
          )}
        </Button>
      </div>
    </section>
  );
}
