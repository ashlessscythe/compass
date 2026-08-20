# Mobile UX milestones

How we sequence Compass iOS UI/UX. Product features (NFC, import, Scryfall) stay in [roadmap.md](./roadmap.md). This file is the **order of work** and the **exit criteria**.

**Current milestone:** UX-3 — Move

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

That loop is **functional, not crafted**. Settings and About are still labeled placeholders. Captures in `docs/images/mobile/` are the old Linux foundation shell.

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
- [ ] Move Binder from Desk to a new Shelf; search “Lightning Bolt” shows `Office / Shelf / Binder / Lightning Bolt` (or the equivalent names you used)
- [ ] Kill/relaunch: still on the new path
- [ ] Illegal moves are blocked (cannot parent a place under itself / its descendant) with a readable error, not a crash

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
- [ ] From an asset, tap the container and the place in the path; both navigate
- [ ] Home, place, container, and asset share spacing, type, and row language
- [ ] Dark and light both remain readable (Settings theme toggle)

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
- [ ] Add place / container / asset from the sheet; list updates live
- [ ] Rename from the sheet; path updates on descendants
- [ ] Dismiss without saving does not create a blank row
- [ ] Widget or integration coverage for the create loop still passes on the 17 Pro

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
- [ ] Every image in the gallery is a 17 Pro frame of the current UI
- [ ] README no longer describes the UI as placeholder-only

**Verify:** open the README gallery; it matches a local run.

---

## After the polish pass

These are roadmap items. Do not pull them forward to avoid UX-1…UX-5.

| Next | When | Tollgate (short) |
|------|------|------------------|
| NFC tag on a container | Physical iPhone; simulator cannot do this | Tap tag → that container opens from local data |
| CSV import | After move + path are trustworthy | File in → items searchable with a path |
| Deckbox / Moxfield | After CSV | Adapter lands in the same import surface |
| Scryfall | Optional enrichment | Catalog off: where-is-it still works; catalog on: art/stats cached |

Sync, billing, household sharing, and the web collection browser stay later / undecided. Do not block iOS on them.

---

## Out of this document

- Website / waitlist / Postgres
- Android-first work
- Module verticals beyond making the generic graph usable
- Pricing
