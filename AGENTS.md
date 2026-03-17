# Repository Guidelines

## Project Structure & Module Organization
- `lib/` contains the Flutter application code (pages, controllers, services, models, and widgets).
- `assets/` holds bundled images, fonts, and other app resources referenced by Flutter.
- `android/` and `ios/` contain the native platform projects.
- `screenshots/` stores UI capture assets used in documentation.
- Generated files follow `*.g.dart` naming and are produced by code generation.

## Build, Test, and Development Commands
- `flutter pub get` installs Dart/Flutter dependencies.
- `dart run build_runner build --delete-conflicting-outputs` generates code (required for `*.g.dart`).
- `flutter build ios --release` produces a release IPA build.
- `flutter build apk --split-per-abi` builds Android APKs per ABI.
- `flutter analyze` runs the Dart analyzer with project lints.
- `dart format .` formats Dart code (run before committing).
- `flutter test` runs tests when a `test/` directory is present.

## Coding Style & Naming Conventions
- Follow `flutter_lints` (see `analysis_options.yaml`).
- Use 2-space indentation (Dart/Flutter default) and prefer lower_snake_case for file names.
- Classes use `UpperCamelCase`; variables and methods use `lowerCamelCase`.
- Keep widgets small and prefer composition over large build methods.

## Testing Guidelines
- Framework: `flutter_test` (declared in `pubspec.yaml`).
- Tests should live under `test/` with descriptive names, e.g. `test/pages/library_page_test.dart`.
- If adding new UI features, include at least a widget test or a focused unit test.

## Commit & Pull Request Guidelines
- Commit messages follow a short, imperative style like `fix icon issue` or `update workflow`.
- Keep commits focused; avoid mixing refactors and feature changes.
- PRs should include a clear description, testing steps, and screenshots for UI changes.
- Link related issues or discussion threads when available.

## Configuration & Release Notes
- Check `config.json` and platform-specific settings before changing API or auth behavior.
- `shorebird.yaml` indicates release tooling is in use; coordinate release changes with maintainers.
