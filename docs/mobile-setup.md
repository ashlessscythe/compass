# Flutter / mobile setup (new Mac)

How to get `apps/mobile` running on a fresh machine. Targets **Flutter 3.44+ / Dart 3.12+** on the **stable** channel.

This app uses **Swift Package Manager** for iOS and macOS plugins, not CocoaPods. There is no `Podfile`. Do not run `pod install`.

## 1. Flutter SDK

Homebrew is enough:

```bash
brew install --cask flutter
flutter doctor
```

Stay on stable:

```bash
flutter channel stable
flutter upgrade
```

## 2. Xcode (iOS and macOS)

Command Line Tools are not enough. Install **Xcode** (App Store or Apple Developer). Beta builds install as `Xcode-beta.app`.

Point `xcode-select` at the full app, then finish first launch and the license:

```bash
# Stable Xcode:
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Or a beta:
sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer

sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license accept
xcodebuild -downloadPlatform iOS
```

Open Xcode once so it can finish installing components.

Confirm:

```bash
xcode-select -p
xcodebuild -version
flutter doctor -v
```

You want a checkmark for **Xcode**. Android and Chrome can stay red until you need them.

## 3. Get packages

```bash
cd apps/mobile
flutter pub get
```

After changing Freezed / Drift / JSON annotated models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 4. Run on macOS (fastest smoke test)

```bash
cd apps/mobile
flutter run -d macos
```

## 5. Run on an iOS simulator

`flutter run -d ios` does **not** work. `ios` is not a device id. Flutter only lists **booted** simulators.

On **Xcode 27+**, Apple replaced **Simulator.app** with **DeviceHub**. `open -a Simulator` will fail.

```bash
open -a DeviceHub
xcrun simctl boot "iPhone 17 Pro"
cd apps/mobile
flutter devices
flutter run -d "iPhone 17 Pro"
```

Device names change with Xcode. List what you have:

```bash
xcrun simctl list devices available
```

Boot by name or by UUID from that list, then pass the same name/UUID to `flutter run -d`.

If `flutter devices` still shows only macOS after a successful `simctl boot`, CoreSimulator may be stale:

```bash
killall -9 CoreDeviceService
```

Then boot again.

Debug builds need `flutter run`. `xcrun simctl launch` without the Flutter tool attached usually shows a white screen.

If the simulator still has a v1 empty database and the graph UI fails to open, delete the Compass app from the simulator and run again. Inventory is `Documents/compass.sqlite` (on-device only).

Smoke the graph after launch: Add place (Office) → nested place (Desk) → container (Binder) → asset (Lightning Bolt) → kill/relaunch → search `Lightning` → path `Office / Desk / Binder / Lightning Bolt`.

### Physical iPhone

Plug it in, trust the computer, and add a Developer Apple ID in Xcode (**Settings → Accounts**). It should appear in `flutter devices`. Signing is configured the first time you run from Xcode or via `flutter run`.

## 6. Android and web (optional)

- **Android:** install Android Studio, an SDK, and a device image, then `flutter doctor --android-licenses`.
- **Web:** install Chrome, then `flutter run -d chrome`.

## Quality

```bash
cd apps/mobile
flutter analyze
flutter test
# Optional: UI loop on a booted simulator
flutter test integration_test/location_graph_test.dart -d "iPhone 17 Pro"
```

## App icons

From the repo root, regenerate marketing + native icons from the site mark:

```bash
pnpm icons
```

iOS/macOS App Store icons must be opaque RGB (no alpha). Do not hand-edit PNGs in `AppIcon.appiconset` — change the SVG / generator instead.

## TestFlight (manual)

Bundle id: `app.compass.mobile`. Bump `version:` in `apps/mobile/pubspec.yaml` (`name+build`) before each upload. Home-screen label is `Compass Inventory` in `ios/Runner/Info.plist` (see [branding.md](./branding.md)). Automating Transporter is a Later roadmap item.

## What not to commit

These are generated on `flutter pub get` / Xcode and are gitignored:

- `**/xcshareddata/swiftpm/` (`Package.resolved` from plugin SPM)
- `ios/Flutter/ephemeral/`, `macos/Flutter/ephemeral/`
- `apps/mobile/build/`, `.dart_tool/`

Keep `pubspec.lock` in git. `ios/Podfile` is required while `sign_in_with_apple` uses CocoaPods (SPM not supported yet).

Sync / API env for local and Production: [environment.md](./environment.md).
