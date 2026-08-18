# Vision

## Purpose

Compass is an offline-first asset management platform.

It bridges the gap between digital inventories and physical storage.

Traditional inventory software answers:

> Do I own this?

Compass answers:

> Where is it?

## Product thesis

Collectors and households already track *what* they own in spreadsheets, apps, and marketplaces. The hard problem is spatial: which box, binder, drawer, shelf, or room holds a specific item — especially when that item has not been touched in months.

Compass makes physical location a first-class dimension of inventory.

## First vertical

**Magic: The Gathering collections**

Collectors often know they own a card. They struggle to find which binder page, deck box, or storage bin contains it. Compass maps catalog entries to nested real-world containers, optionally identified by NFC tags.

Card images and stats (mana, type, oracle text, set) come from **Scryfall** by default. That lookup is configurable and optional: Compass still answers *where it is* if the catalog is off or the device is offline. Fetched art/stats are cached locally. Other modules will use their own catalog providers the same way.

## Future modules

The architecture is module-based so additional verticals can share the same location graph:

- Tools
- Jewelry
- Watches
- Clothing
- LEGO
- Electronics
- Home Inventory
- Documents
- Camera Equipment
- Collectibles

## Design principles

1. **Offline first** — Core workflows work without connectivity.
2. **Location native** — Every asset can answer “where.”
3. **Tap to open** — NFC tags turn containers into instant entry points.
4. **Import friendly** — Meet collectors where their data already lives.
5. **Universal core** — Domain modules plug into a shared location + asset model.
6. **Premium craft** — Software should feel as considered as the objects people care about.

## Brand

- **Name:** Compass
- **Tagline:** Know where everything is.
- **Domain:** getcompass.space
- **Tone:** Minimal, elegant, modern — premium software startup, not fantasy.
