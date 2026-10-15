/// orders module.
///
/// Clean-architecture layout (mirror `packages/modules/auth`):
/// - `src/domain/` — entities, repository interfaces, use-cases (pure Dart).
/// - `src/data/` — retrofit datasources, models, repository implementations.
/// - `src/presentation/` — cubits + pages (flutter).
/// - `src/di/` — `registerXModule()` wiring getIt (called by each app).
library;
