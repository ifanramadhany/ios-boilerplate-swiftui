# IOSBoilerplate

IOSBoilerplate is a SwiftUI iOS project structured for a growing team and a large codebase.

## Project Structure

```text
IOSBoilerplate
├── App
├── Core
│   ├── Networking
│   ├── Persistence
│   ├── Config
│   ├── DependencyInjection
│   ├── Analytics
│   └── Logging
├── Features
│   └── Home
│       ├── Views
│       ├── ViewModels
│       ├── Models
│       └── Services
├── DesignSystem
│   ├── Components
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   └── Theme
├── Shared
│   ├── Extensions
│   ├── Utilities
│   └── Constants
├── Resources
│   ├── Assets.xcassets
│   ├── Localization
│   └── Fonts
├── Tests
└── UITests
```

## Folder Rules

- `App`: app entry point, app-level bootstrap, navigation root, dependency setup.
- `Core`: infrastructure that is not feature-specific, such as networking, persistence, configuration, logging, and dependency injection.
- `Features`: user-facing product areas. Prefer adding code here first before promoting it to shared layers.
- `DesignSystem`: reusable UI components, design tokens, typography, colors, spacing, and app-wide UI primitives.
- `Shared`: small reusable helpers, extensions, and utilities that are not infrastructure and not feature-owned.
- `Resources`: asset catalogs, localized strings, fonts, and bundled static files.
- `Tests`: unit and integration tests.
- `UITests`: UI automation tests.

Avoid using `Core` or `Shared` as general dumping grounds. Code should become shared only when at least two real call sites need it or when it is clearly infrastructure.

## Feature Layout

Use feature folders for product areas:

```text
Features
└── Home
    ├── Views
    ├── Models
    ├── ViewModels
    └── Services
```

Keep feature-specific models, view models, services, and views inside the feature. Move code to `Core`, `DesignSystem`, or `Shared` only when the ownership is clearly cross-feature.

## Requirements

- Xcode 16.0 or newer
- iOS deployment target: 17.0
- Swift 6 language mode
- SwiftUI
- Swift Testing / XCTest

## Build

From the repository root:

```sh
make build
```

This builds the app for a generic iOS Simulator destination, which is the most reliable local and CI compile check because it does not require signing or a physical device.

To check a generic physical-device build, run:

```sh
make device-build
```

## Tests

Run unit tests:

```sh
make test
```

Run a test build without executing tests:

```sh
make test-build
```

Run UI tests separately:

```sh
make ui-test
```

Keep unit tests and UI tests separate in local and CI checks. Unit tests verify app logic quickly. UI tests launch the simulator and can fail for simulator or automation reasons, so they should be reported separately.

## Code Quality

Install SwiftLint and SwiftFormat:

```sh
brew bundle
```

Run lint:

```sh
make lint
```

Format code:

```sh
make format
```

Check formatting without changing files:

```sh
make format-check
```

The project keeps SwiftLint and SwiftFormat as command-line tools instead of mandatory Xcode build phases. This avoids breaking local builds when a developer has not installed the tools yet. CI should install and run them for pull requests.

## Pull Request Checks

Every pull request to `main` should pass the GitHub Actions workflow in `.github/workflows/ci.yml`.

The workflow runs:

```sh
make format-check
make lint
make build
make test-build
```

Before opening a pull request, run:

```sh
make format
make lint
make build
make test
```

Use `make test-build` in CI for deterministic compile verification, and run `make test` locally or in a dedicated unit-test job when a matching simulator runtime is available. You can override the simulator without editing the Makefile:

```sh
make test TEST_DESTINATION='platform=iOS Simulator,name=iPhone 17,OS=26.5'
```

Repository maintainers should enable branch protection for `main` in GitHub and require the `Quality and Build` check before merging.

## Swift Package Manager

Use Swift Package Manager through Xcode when the app needs third-party libraries:

```text
Xcode -> File -> Add Package Dependencies...
```

When packages are added, commit the generated `Package.resolved` file. It locks package versions so local builds and CI use the same dependency graph.

## Team Conventions

- Keep pull requests focused and small enough to review.
- Add or update tests for behavior changes.
- Keep target membership correct: app code belongs to the app target, unit tests to `IOSBoilerplateTests`, and UI tests to `IOSBoilerplateUITests`.
- Prefer feature ownership over broad shared abstractions.
- Construct feature dependencies in `DependencyContainer`; do not create concrete services inside view models.
- Keep view models testable by injecting protocols for services, clients, stores, and trackers.
- Add tests for infrastructure behavior before multiple features depend on it.
- Keep `Core` protocols small, and add concrete persistence, logging, or analytics implementations only when the app has a real use case.
- Do not commit user-specific Xcode files such as `xcuserdata`.
- Document new architecture decisions in this README or a future `Docs/` folder.

## Recommended Next Tooling

- Branch protection on `main` requiring CI to pass before merge.
