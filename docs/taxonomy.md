# Taxonomy and domain schema

Compass is an offline-first **physical asset graph**. The core answers *what is this, where is it, what is it related to, and what happened to it*. Domain modules answer *which attributes matter for this kind of thing*.

Adding a vertical (jewelry, tools, clothing, …) must be primarily a **schema and data** problem. It must not require new columns on the core Asset entity.

**Rule:** never add Magic: The Gathering, jewelry, tools, clothing, firearms, or any other vertical fields to `Asset`, `Location`, `Container`, or `AssetType` beyond the generic fields below.

This document is the target architecture. Implementation stays incremental — see [Phasing](#phasing). Current persistence and entity inventory: [architecture.md](./architecture.md).

---

## Separation of concerns

Do not model Compass as one widening asset table:

```text
Asset
├── mtgSet
├── collectorNumber
├── foil
├── material
├── carat
├── serialNumber
├── shoeSize
└── …
```

That produces a pile of nullable, domain-specific columns and makes every vertical a core schema change.

Instead, separate:

1. Core asset identity
2. Asset type (optional hierarchy)
3. Schema (attribute definitions bound to a type or module)
4. Attribute values
5. Controlled vocabularies
6. Taxonomy (classification graph, versioned)
7. External identifiers and datasets
8. Domain modules / packs (importers, providers, UI)

```text
Asset
  → Asset Type
    → Schema
      → Attribute definitions
        → Values (canonical where a vocabulary exists)
```

---

## Core asset

An Asset is a generic tracked item. It may contain:

| Concept | Notes |
|---------|--------|
| Identity | Stable internal id. Survives taxonomy updates. |
| Asset type | `assetTypeId` — what kind of thing this is |
| Name, notes | Display + free text |
| Quantity | Count of this item in this place |
| Location / container | *Where* — the location graph |
| Photos, tags | Separate entities, not columns on Asset |
| History | Separate entity |
| Attributes | Typed values keyed by definition — **not** vertical columns |
| Metadata | Interim bag for module fields until attribute tables persist |

**Not on Asset:** set, collector number, foil, material, carat, serial number, shoe size, warranty, mana cost, oracle text, hallmark, or any other domain field.

Photos, tags, movements, and history are already modeled as their own entities. Do not flatten them onto Asset when they land in SQLite.

---

## Asset type

An Asset Type names a kind of thing: `mtg_card`, `jewelry`, `ring`, `watch`, `power_tool`, `shoe`, `lego_set`, `book`, `lens`.

Types may form a tree of arbitrary depth:

```text
Jewelry
├── Ring
│   ├── Engagement Ring
│   └── Wedding Band
├── Necklace
└── …

Tool
├── Hand Tool
│   ├── Wrench
│   └── …
└── Power Tool
    ├── Drill
    └── …
```

`AssetType.moduleId` (`mtg`, `jewelry`, `tools`, …) is the vertical this type belongs to. `parentId` is the optional parent type.

The seeded default is generic `Item` (`collectibles`) so the location graph works before a type picker exists.

---

## Attributes

Attributes are data-driven. A type’s schema is a list of definitions, not columns.

```json
{
  "type": "jewelry",
  "attributes": [
    { "key": "material", "type": "enum" },
    { "key": "gemstone", "type": "reference" },
    { "key": "carat", "type": "decimal", "unit": "ct" },
    { "key": "style", "type": "enum" },
    { "key": "era", "type": "date_range" }
  ]
}
```

Supported value types (more can be added later):

`string` · `integer` · `decimal` · `boolean` · `date` · `date_range` · `enum` · `multi_select` · `reference` · `measurement` · `currency` · `url` · `identifier`

The UI should eventually generate forms from the active type’s schema (jewelry ring vs drill). Do not build that UI until catalog work — [mobile-ux.md](./mobile-ux.md) still uses a name-only create sheet.

**Today:** module-specific fields live in `Metadata` (`Map<String, dynamic>`). Prefer canonical keys even in that bag. Typed `AttributeDefinition` / `AttributeValue` entities exist in the domain layer; SQLite tables come when a consumer needs them (MTG catalog or the taxonomy phase).

---

## Controlled vocabularies

Do not store uncontrolled aliases as distinct values:

```text
Gold  /  gold  /  14k gold  /  14K  /  14 Karat  /  14-karat gold
```

Normalize to a stable canonical key:

```text
material.gold.14k
```

Display names may vary by locale. The identifier does not. That is what makes search, filters, analytics, import normalization, and cross-domain joins possible.

---

## External taxonomies and identifiers

Compass must not lock to a single external taxonomy. Any entity can carry many external ids:

```text
Compass entity
  ├── Wikidata        Q12345
  ├── Google taxonomy 166
  └── Domain dataset  GEM-000123
```

Treat external systems as **imports and references**, not as the internal model.

| Source | Role |
|--------|------|
| Google Product Taxonomy | Broad consumer categories (apparel, jewelry, tools) |
| UNSPSC | Procurement-style segment → family → class → commodity |
| Wikidata | Reference entities and links (gemstone, maker, brand, country). Import only what a domain needs — do not mirror Wikidata. |
| Domain datasets | Jewelry hallmarks, gemstones, assay offices; MTG via Scryfall; etc. |

Store `source` + `external_id`. Taxonomies are versioned (`taxonomy_id`, `version`, `source`, `imported_at`). User assets keep Compass ids if a classification changes; updates must not silently destroy values.

---

## Domain modules and packs

The core platform does not know how an MTG card differs from a ring. A **module** (later, an installable **domain pack**) provides:

- Asset types and schemas
- Controlled vocabularies and reference data
- Importers
- External metadata providers
- Domain UI and workflows

```text
Compass
├── Core (location graph, NFC, search, history, sync)
├── MTG / Card pack     — Scryfall, Deckbox, Moxfield, pricing providers
├── Jewelry pack        — taxonomy, gemstones, hallmarks
├── Clothing pack
└── Workshop / tools pack
```

Pricing providers stay abstract (`PricingProvider`: TCGplayer, Cardmarket, …). Catalog providers stay optional enrichment: *where* still works if Scryfall is off.

Offline: types, attribute definitions, vocabularies, and the taxonomy rows needed for normal use live on device. Do not download entire external graphs. Prefer domain packs and incremental updates.

---

## Examples

### MTG (first vertical)

Type: `mtg_card`. Attributes such as name, set, collector number, finish, condition, language, rarity, mana cost, oracle text live on the schema — not on Asset. Scryfall ids belong in external identifiers (or Metadata until that table exists). Compass still answers *where the card is*.

### Jewelry

```text
Jewelry → Ring → Engagement Ring
```

Attributes: material, purity, gemstone, carat, cut, color, clarity, style, era, maker, hallmark, purchase / appraisal / insurance values. Gold, diamond, and similar references are controlled values, not free text.

---

## Phasing

Do not build the entire taxonomy system in the iOS UX pass.

| Phase | Build | Do not pull forward |
|-------|--------|---------------------|
| **Foundation** (now) | Generic Asset + Asset Type (incl. quantity, type hierarchy). Domain types for attribute definitions, values, controlled vocabularies, external identifiers. Metadata as the persisted attribute bag. | Schema-driven forms, taxonomy import, domain packs |
| **MTG** | MTG schema, Scryfall, importers, pricing provider interface | Jewelry / tools packs |
| **Taxonomy** | Taxonomy model + versioning, external import, reference entities, persist attribute tables | Full Wikidata / UNSPSC mirrors |
| **Expansion** | Domain packs (jewelry, tools, clothing, collectibles, …) | Core Asset column changes |

MTG is the first domain pack. Sequence and tollgates: [domain-packs-roadmap.md](./domain-packs-roadmap.md).

[roadmap.md](./roadmap.md) is the product sequence. This file is the schema contract those items must satisfy.
