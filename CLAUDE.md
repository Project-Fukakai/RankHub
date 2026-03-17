# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RankHub is a cross-platform Flutter app (iOS/Android) for managing rhythm game data across multiple platforms. It aggregates scores, player stats, and game metadata from services like LXNS (落雪咖啡屋), DivingFish, MuseDash.moe, Phigros, and osu!.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Code generation (REQUIRED after changing Isar models or Riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Lint
flutter analyze

# Build release
flutter build ios --release
flutter build apk --split-per-abi
```

There are no tests in this project.

## Key Dependencies

- **GetX**: Uses a forked version from `https://github.com/luis901101/getx_fork.git` (ref: old-4.7.0). Never use GetX from pub.dev.
- **Isar Community**: Local NoSQL database with code generation (`@collection` annotation). Run build_runner after model changes.
- **simai_flutter**: Local path dependency at `../../simai_flutter` — must exist on disk to build.
- **Riverpod + Go Router**: Newer architecture layer in `lib/core/`, coexisting with the GetX system.

## Architecture

### Two Coexisting Architecture Layers

1. **Original (GetX-based)**: `lib/models/`, `lib/modules/`, `lib/controllers/`, `lib/services/`, `lib/routes/`
   - State: GetX `.obs` reactive properties, `Obx(() => ...)` in UI
   - Routing: `Get.toNamed()` with routes in `lib/routes/app_routes.dart`, bindings in `lib/routes/app_pages.dart`
   - DI: `BindingsBuilder` for controller injection

2. **Newer (Riverpod-based)**: `lib/core/`
   - Immutable `AppContext` pattern — switching game/account rebuilds the entire context
   - `AppContextNotifier` (Riverpod `Notifier`) manages current state
   - `ResourceLoader` / `ResourceScope` / `PlatformAdapter` abstractions for data access

### Platform-Game Two-Level Abstraction

```
PlatformRegistry (singleton, lib/data/platforms_data.dart)
  └── IPlatform (lib/models/platform.dart)
        ├── PlatformLoginHandler — auth UI (WebView for OAuth2, forms for API key/password)
        ├── CredentialProvider — token lifecycle (get, refresh, validate, revoke)
        └── List<IGame> — game implementations
              ├── buildWikiViews() — song lists, metadata
              └── buildRankViews() — scores, rankings
```

Registered platforms: LXNS, DivingFish, MuseDash, Phigros, osu! (in `PlatformRegistry._platforms`).

### Data Flow

```
Page → Controller → Service → Platform/Game → API (Dio) / Database (Isar)
```

### Module Structure

Each platform lives in `lib/modules/{platform_name}/` with:
- Platform implementation (extends `BasePlatform`)
- Game implementations (extend `IGame`)
- `services/` — LoginHandler, CredentialProvider, API service
- `widgets/` — platform-specific UI components
- `controllers/` — GetX controllers
- `pages/` — platform-specific pages

### Authentication

Three credential types, each with a base class in `lib/services/credential_provider.dart`:
- **OAuth2** (`OAuth2CredentialProvider`): PKCE flow via WebView (`lib/utils/pkce_helper.dart`), auto-refresh
- **API Key** (`ApiKeyCredentialProvider`): Static key stored in `account.apiKey`
- **Username/Password** (`UserPasswordCredentialProvider`): Basic auth

### Data Sync

`SyncManager` (`lib/services/sync_manager.dart`):
- Max 3 concurrent tasks
- Platforms implement `createFullSyncTasks(Account)` returning a `SyncTaskGroup`
- Task types: metadata, songs, collections, scores, players
- States: pending → running → completed/failed/cancelled

### Database

Isar with multi-database architecture: separate DB per game + shared account DB. Access via `IsarService.instance`. Services extend `BaseIsarService` with custom `databaseName` and `schemas`.

## Conventions

- Snake_case for all Dart files: `maimai_dx_game.dart`, `lxns_credential_provider.dart`
- All routes as constants in `AppRoutes` class
- UI: Bottom navigation (Wiki/Rank/Mine tabs), blur effects on bottom bar, `AnimatedSwitcher` for tab transitions
- New platforms must be registered in `PlatformRegistry._platforms` in `lib/data/platforms_data.dart`
- Build-time secrets injected via `config.json` with `--dart-define-from-file` (CI only)

## Adding a New Platform

1. Create `lib/modules/{platform}/` with platform, game, services, widgets
2. Extend `BasePlatform` — implement `loginHandler`, `credentialProvider`, `getGames()`, `createFullSyncTasks()`
3. Implement `PlatformLoginHandler.showLoginPage()` for auth UI
4. Implement appropriate `CredentialProvider` subclass
5. Register in `PlatformRegistry._platforms`
6. If adding Isar models, run `build_runner`

## Adding a New Game

1. Implement `IGame` with `buildWikiViews()` and `buildRankViews()`
2. Create Isar `@collection` models if local storage needed
3. Create service extending `BaseIsarService`
4. Add to parent platform's `getGames()` list
5. Run `build_runner` if models were added
