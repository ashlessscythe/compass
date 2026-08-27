# Mobile UX milestones

How we sequence Compass iOS UI/UX. Product features (NFC, import, Scryfall) stay in [roadmap.md](./roadmap.md). This file is the **order of work** and the **exit criteria**.

**Current milestone:** Later platform work (CSV export shipped — see [roadmap.md](./roadmap.md)). Store product cutover is in: Pro lifetime + Sync monthly/yearly; legacy `compass` still grants Pro. Offline-first sync v0 is in place ([sync-protocol.md](./sync-protocol.md)). Feature entitlements (Free / Pro / Sync); Themes / bulk refetch gate on Pro; Sync gates cloud push/pull.

Do not start the next milestone until the current tollgate is met on iPhone 17 Pro. Branch from `dev`. Stay on Material 3 / the existing theme — no Cupertino rewrite.

## How to use this

1. Work one milestone at a time.
2. A tollgate is binary: either the loop works on a cold simulator launch, or it does not.
3. If a later milestone needs a schema or service change, do the smallest backend needed *inside that milestone*. Do not pre-build NFC, import, or catalog UI.
4. Recapture stills only when the polish pass says so (UX-6). Do not refresh `docs/images/mobile/` on every slice.

Brand bar: [branding.md](./branding.md) — dark-first, large type, generous spacing, glass only when it clarifies hierarchy, cool steel accent. Splash and Home already lean this way; graph screens do not.

Simulator: `flutter run -d "iPhone 17 Pro"` — see [mobile-setup.md](./mobile-setup.md). NFC will not work here.

---

## Done — Graph loop (data)

Inventory persists in on-device SQLite. You can add a place, nest a place, add a container, add an asset, search by name, and see the path. Data survives kill/relaunch.

That loop is **functional, not crafted**. Settings and About are still labeled placeholders. Gallery stills are iPhone 17 Pro frames of the current graph UI (see UX-6).

---

## UX-1 — First run

Empty Compass should teach the one action that starts the product: add a place.

**In**
- Home empty state: short copy + a primary “Add place” control (not a leftover text button under “Nothing here yet.”)
- After the first place exists, empty copy goes away; Places list + search remain
- Place and container screens that have no children get the same treatment (one obvious add action, not a dead “No nested X yet.” line)

**Out**
- Onboarding carousel, accounts, sample seed data
- Visual redesign of Home beyond the empty state

**Tollgate**
- [x] Fresh install (no sqlite): Home explains the product in one sentence and the only primary action is Add place
- [x] After adding “Office”: empty state is gone; Office is listed; search still works
- [x] Opening an empty Office: one obvious way to add a nested place or a container

**Verify:** delete the app from the 17 Pro (or clear `compass.sqlite`), launch, add a place, relaunch.

---

## UX-2 — Confirm delete

Delete is instant today. That is not acceptable once people have nested data.

**In**
- Confirm before deleting a place, container, or asset
- Copy that says what will go away (the thing, and that children go with it when that is true)
- Cancel leaves data unchanged

**Out**
- Undo toasts, recycle bin, soft-delete schema
- Move (that is UX-3)

**Tollgate**
- [x] Delete → cancel → item still there, path still searchable
- [x] Delete → confirm → item gone, search no longer finds it
- [x] Deleting a place that has children is explicit (not a silent cascade surprise)

**Verify:** Office → Desk → Binder → Lightning Bolt. Cancel delete on Binder. Confirm delete on the asset. Search both names.

---

## UX-3 — Move

You can nest on create. You cannot reparent later. “Where is it?” is incomplete if things cannot change location.

**In**
- Move a place under another place (or to root)
- Move a container to another container or place
- Move an asset to another container
- Path recomputes; search shows the new path

**Out**
- Drag-and-drop trees, multi-select, bulk move
- NFC

**Tollgate**
- [x] Move Binder from Desk to a new Shelf; search “Lightning Bolt” shows `Office / Shelf / Binder / Lightning Bolt` (or the equivalent names you used)
- [x] Kill/relaunch: still on the new path
- [x] Illegal moves are blocked (cannot parent a place under itself / its descendant) with a readable error, not a crash

**Verify:** the move loop above, plus one rejected cycle.

---

## UX-4 — Shared chrome

Home has the brand (mark, display type, gradient). Detail screens are a bare app bar + list. They should feel like one app.

**In**
- One page shell for place / container / asset (padding, type, surfaces)
- Tappable breadcrumbs / path: tap a segment, land on that node
- Graph rows that look considered (not default `ListTile` leftovers) while staying scannable
- Asset detail leads with **where**, not a sparse “Where” heading and a string

**Out**
- Bottom tabs, a new IA, settings redesign
- Glass everywhere — only if it helps hierarchy

**Tollgate**
- [x] From an asset, tap the container and the place in the path; both navigate
- [x] Home, place, container, and asset share spacing, type, and row language
- [x] Dark and light both remain readable (Settings theme toggle)

**Verify:** Lightning Bolt → tap Binder → tap Desk → back to Home. Toggle theme on a detail screen.

---

## UX-5 — Create / rename sheet

Name prompts are `AlertDialog`s. They work. They do not match the rest of the craft.

**In**
- Create and rename use a modal sheet (name field, cancel, confirm)
- Autofocus, submit-from-keyboard, no duplicate-on-dismiss bugs (already fixed once — do not regress)
- Optional notes field only if it stays one screen; skip type pickers until catalog work

**Out**
- Full editors, photos, tags, metadata JSON UI

**Tollgate**
- [x] Add place / container / asset from the sheet; list updates live
- [x] Rename from the sheet; path updates on descendants
- [x] Dismiss without saving does not create a blank row
- [x] Widget or integration coverage for the create loop still passes on the 17 Pro

**Verify:** create + rename + cancel on one place and one asset. `flutter test integration_test/location_graph_test.dart -d "iPhone 17 Pro"`

---

## UX-6 — Phone stills

Docs still show the Linux foundation placeholder. Replace them only after UX-1…UX-5.

**In**
- iPhone 17 Pro captures of: empty Home, Home with a graph, search hit with path, place, container, asset (where)
- Update `docs/images/mobile/README.md` and the mobile README gallery
- No desktop chrome, no marketing-hero claims

**Out**
- App Store screenshots, marketing site takeover

**Tollgate**
- [x] Every image in the gallery is a 17 Pro frame of the current UI
- [x] README no longer describes the UI as placeholder-only

**Verify:** open the README gallery; it matches a local run.

---

## After the polish pass

These are roadmap items. Do not pull them forward to avoid UX-1…UX-5.

| Next | When | Tollgate (short) |
|------|------|------------------|
| NFC tag on a container | Done — physical iPhone; chip UID in `nfcTagId` | Tap tag → that container opens from local data |
| CSV import | Done — Settings → Import CSV | File in → items searchable with a path |
| Deckbox / Moxfield | Done — auto-detected header dialects on the CSV surface | Adapter lands in the same import surface |
| Scryfall | Done — Settings → MTG catalog; Match after import; container thumbs | Catalog off: where works; on: art/stats from local SQLite cache |
| Themes + sub | Done — Settings → Themes; `compass_pro_lifetime` → Pro; legacy `compass` still grants Pro | Free Dark/Light/Gray; Pro ambience + accent + bulk refetch |
| Offline catalog art | Done — JPG cache + match prefetch small/normal | Airplane: show cached art; miss → placeholder (no crash) |
| Feature entitlements | Done — monetization.md; `canUse(Feature)`; mock Free/Pro/Sync | Themes + bulk refetch gate on Pro features |
| Offline-first sync | Done — sync-protocol.md; Settings → Sync | Local SoT; outbox + Postgres push/pull; Sync-gated |
| Store product cutover | Done — Pro lifetime + Sync monthly/yearly; stop selling `compass_monthly` | Buy Pro / subscribe Sync; restore; grandfather `compass` |

Sync Plus, household sharing, and the web collection browser stay Later. Themes / Pro paywall stays a calm sheet only (never launch interstitial).

---

## Out of this document

- Website / waitlist / Postgres
- Android-first work
- Module verticals beyond making the generic graph usable
- Pricing
