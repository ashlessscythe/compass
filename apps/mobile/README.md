# Compass Mobile

Offline-first asset management for iOS, Android, and desktop.

**Compass** — *Know where everything is.*

## Prerequisites

Use the **stable** channel. This project targets Dart 3.12+ / Flutter 3.44+.

Full new-Mac walkthrough (Xcode, DeviceHub, iOS simulator, what not to commit): [docs/mobile-setup.md](../../docs/mobile-setup.md).

UI/UX sequence and tollgates: [docs/mobile-ux.md](../../docs/mobile-ux.md).

```bash
brew install --cask flutter
flutter doctor
```

## Setup

```bash
cd apps/mobile
flutter pub get
```

Generate Freezed / Drift / JSON code after changing annotated models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Run

```bash
flutter run
```

Pick a device when prompted, or target one explicitly:

```bash
flutter run -d chrome           # web (needs Chrome)
flutter run -d macos            # macOS
flutter run -d linux            # Linux
flutter run -d "iPhone 17 Pro"  # booted iOS simulator (see docs/mobile-setup.md)
```

## Supported platforms

| Platform | Status |
|----------|--------|
| iOS      | Supported |
| Android  | Supported |
| macOS    | Supported |
| Linux    | Supported |
| Windows  | Supported |
| Web      | Supported (dev / preview; requires `web/sqlite3.wasm` + `web/drift_worker.js`) |

## Architecture overview

Clean Architecture, feature-first:

```
lib/
├── core/                 # Shared kernel
│   ├── constants/
│   ├── domain/           # Entities + repository contracts
│   ├── errors/
│   └── utils/
├── features/             # Vertical slices
│   ├── assets/
│   ├── containers/
│   ├── locations/
│   ├── home/
│   ├── splash/
│   ├── settings/
│   └── about/
│       ├── presentation/
│       ├── application/
│       ├── domain/
│       └── infrastructure/
├── database/             # Drift SQLite + migrations
├── routing/              # GoRouter
├── theme/                # Material 3 tokens (dark-first)
├── services/             # Cross-cutting services
├── shared/               # Providers, shared infrastructure
└── widgets/              # Reusable UI primitives
```

### Layers

| Layer | Responsibility |
|-------|----------------|
| **presentation** | Widgets, pages — no business logic |
| **application** | Use cases / services, Riverpod notifiers |
| **domain** | Entities, value objects, repository interfaces |
| **infrastructure** | Drift DAOs, repository implementations |

### Core domain

The platform is built around generic concepts — never module-specific fields:

`Asset` · `Container` · `Location` · `AssetType` · `Movement` · `Relationship` · `History` · `Tag` · `Metadata` · `Photo` · `AttributeDefinition` · `AttributeValue` · `ControlledValue` · `ExternalIdentifier`

Module-specific data (MTG, jewelry, tools, …) belongs in attribute values (or `Metadata` until those tables persist), not columns on Asset. See [docs/taxonomy.md](../../docs/taxonomy.md).

### Stack

- **Flutter** + Material 3
- **Riverpod** / **hooks_riverpod** + **flutter_hooks**
- **GoRouter**
- **Drift** (SQLite)
- **Freezed** + **json_serializable** + **build_runner**
- **uuid**
- **very_good_analysis**

### Quality

```bash
flutter analyze
flutter test
flutter test integration_test/location_graph_test.dart -d "iPhone 17 Pro"

# Recapture docs stills (iPhone 17 Pro simulator):
./tool/capture_ux_stills.sh
```

## Notes

- Location graph persists in SQLite (Drift). Search by name shows the physical path.
- Do not put business logic in widgets.

## UI captures

iPhone 17 Pro stills of the location graph (empty Home → path search → asset
where). Full set: [`docs/images/mobile/`](../../docs/images/mobile/).

### Empty Home

![Empty Home](../../docs/images/mobile/01-empty-home.png)

### Home with a graph

![Home with graph](../../docs/images/mobile/02-home-graph.png)

### Search hit with path

![Search with path](../../docs/images/mobile/03-search-path.png)

### Place

![Place](../../docs/images/mobile/04-place.png)

### Container

![Container](../../docs/images/mobile/05-container.png)

### Asset (where)

![Asset where](../../docs/images/mobile/06-asset-where.png)
