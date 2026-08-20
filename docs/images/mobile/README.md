# Mobile UI captures — iPhone 17 Pro

Stills from the Compass Flutter client on the **iPhone 17 Pro** simulator after the
iOS UX pass (UX-1…UX-6). Dark theme, clean status bar (`9:41`).

These are **layout references** for docs and the mobile README — not App Store
or marketing heroes.

## Empty Home

![Empty Home — add a place](./01-empty-home.png)

## Home with a graph

![Home dashboard with Office](./02-home-graph.png)

## Search hit with path

![Search Lightning → path](./03-search-path.png)

## Place

![Office place detail](./04-place.png)

## Container

![Binder container detail](./05-container.png)

## Asset (where)

![Lightning Bolt — where](./06-asset-where.png)

## Recapture

```bash
cd apps/mobile
./tool/capture_ux_stills.sh
```

Requires a booted iPhone 17 Pro simulator. The script walks the graph via an
integration test and writes PNGs with `xcrun simctl io … screenshot`.
