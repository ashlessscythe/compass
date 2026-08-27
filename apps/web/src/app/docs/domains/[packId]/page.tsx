import Link from "next/link";
import { notFound } from "next/navigation";
import { getDomainPack } from "@compass/domains";
import type {
  DomainPackAssetType,
  DomainPackAttributeDefinition,
  DomainPackCsvExportColumn,
  DomainPackCsvField,
} from "@compass/api";

import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { PackInstallUrl } from "@/components/domains/pack-install-url";

type PageProps = {
  params: Promise<{ packId: string }>;
};

function columnSource(column: DomainPackCsvExportColumn): string {
  if (column.source) {
    return column.source;
  }
  if (column.attributeKey) {
    return `attribute:${column.attributeKey}`;
  }
  return "—";
}

export default async function DomainPackDocsPage({ params }: PageProps) {
  const { packId } = await params;
  const pack = getDomainPack(packId);

  if (!pack) {
    notFound();
  }

  return (
    <>
      <SiteHeader />
      <main id="main" className="mx-auto max-w-3xl px-6 pb-24 pt-28">
        <Link
          href="/docs/domains"
          className="text-sm text-muted-foreground hover:text-foreground"
        >
          ← Domain packs
        </Link>
        <h1 className="mt-4 font-display text-3xl font-semibold tracking-tight md:text-4xl">
          {pack.displayName}
        </h1>
        <p className="mt-2 text-muted-foreground">{pack.description}</p>
        <p className="mt-2 text-sm text-muted-foreground">
          Pack <code className="text-foreground">{pack.id}</code> · module{" "}
          <code className="text-foreground">{pack.moduleId}</code> · version{" "}
          {pack.version}
        </p>

        <PackInstallUrl packId={pack.id} />

        <section className="mt-12">
          <h2 className="font-display text-xl font-medium">Asset types</h2>
          <ul className="mt-4 space-y-2 text-sm">
            {pack.assetTypes.map((assetType: DomainPackAssetType) => (
              <li key={assetType.id}>
                <code>{assetType.id}</code> — {assetType.name}
              </li>
            ))}
          </ul>
        </section>

        <section className="mt-12">
          <h2 className="font-display text-xl font-medium">Attributes</h2>
          <div className="mt-4 overflow-x-auto rounded-xl border border-white/10">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="border-b border-white/10 text-muted-foreground">
                  <th className="px-4 py-3 font-medium">Key</th>
                  <th className="px-4 py-3 font-medium">Type</th>
                  <th className="px-4 py-3 font-medium">Label</th>
                </tr>
              </thead>
              <tbody>
                {pack.attributeDefinitions.map((attr: DomainPackAttributeDefinition) => (
                  <tr
                    key={attr.id}
                    className="border-b border-white/5 last:border-0"
                  >
                    <td className="px-4 py-3 font-mono text-xs">{attr.key}</td>
                    <td className="px-4 py-3">{attr.valueType}</td>
                    <td className="px-4 py-3">{attr.displayName ?? "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section className="mt-12">
          <h2 className="font-display text-xl font-medium">CSV import</h2>
          <p className="mt-2 text-sm text-muted-foreground">
            Header aliases recognized per field. Dialects:{" "}
            {pack.csvImport.dialects.map((d) => d.id).join(", ")}.
          </p>
          <ul className="mt-4 space-y-3 text-sm">
            {pack.csvImport.fields.map((field: DomainPackCsvField) => (
              <li key={field.key}>
                <span className="font-medium">{field.key}</span>
                {field.required ? " (required)" : ""}
                {field.attributeKey ? (
                  <span className="text-muted-foreground">
                    {" "}
                    → {field.attributeKey}
                  </span>
                ) : null}
                <div className="mt-1 font-mono text-xs text-muted-foreground">
                  {field.headerAliases.join(" · ")}
                </div>
              </li>
            ))}
          </ul>
        </section>

        <section className="mt-12">
          <h2 className="font-display text-xl font-medium">CSV export</h2>
          <div className="mt-4 overflow-x-auto rounded-xl border border-white/10">
            <table className="w-full text-left text-sm">
              <thead>
                <tr className="border-b border-white/10 text-muted-foreground">
                  <th className="px-4 py-3 font-medium">Column</th>
                  <th className="px-4 py-3 font-medium">Source</th>
                </tr>
              </thead>
              <tbody>
                {pack.csvExport.columns.map((column: DomainPackCsvExportColumn) => (
                  <tr
                    key={column.header}
                    className="border-b border-white/5 last:border-0"
                  >
                    <td className="px-4 py-3">{column.header}</td>
                    <td className="px-4 py-3 font-mono text-xs">
                      {columnSource(column)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        {pack.providers.catalog ? (
          <section className="mt-12">
            <h2 className="font-display text-xl font-medium">Catalog provider</h2>
            <p className="mt-2 text-sm">
              <code>{pack.providers.catalog.id}</code>
            </p>
            <p className="mt-2 text-sm text-muted-foreground">
              Match keys (in order):{" "}
              {pack.providers.catalog.matchKeys.join(" → ")}
            </p>
          </section>
        ) : null}

        <p className="mt-12 text-sm text-muted-foreground">
          Full JSON:{" "}
          <Link
            href={`/api/domains/${pack.id}`}
            className="text-primary hover:underline"
          >
            /api/domains/{pack.id}
          </Link>
        </p>
      </main>
      <SiteFooter />
    </>
  );
}
