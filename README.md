# IOSBoilerplate

IOSBoilerplate is a SwiftUI iOS project structured for a growing team and a large codebase.

## Project Structure

```text
IOSBoilerplate
├── App
├── Core
├── Features
├── DesignSystem
├── Shared
├── Resources
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

- Xcode 26.5 or newer
- iOS deployment target: 26.5
- SwiftUI
- Swift Testing / XCTest

## Build

From the repository root:

```sh
xcodebuild \
  -project IOSBoilerplate.xcodeproj \
  -scheme IOSBoilerplate \
  -destination generic/platform=iOS \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Test Build

```sh
xcodebuild \
  -project IOSBoilerplate.xcodeproj \
  -scheme IOSBoilerplate \
  -destination generic/platform=iOS \
  CODE_SIGNING_ALLOWED=NO \
  build-for-testing
```

Run tests from Xcode when simulator access and signing are configured.

## Team Conventions

- Keep pull requests focused and small enough to review.
- Add or update tests for behavior changes.
- Keep target membership correct: app code belongs to the app target, unit tests to `IOSBoilerplateTests`, and UI tests to `IOSBoilerplateUITests`.
- Prefer feature ownership over broad shared abstractions.
- Do not commit user-specific Xcode files such as `xcuserdata`.
- Document new architecture decisions in this README or a future `Docs/` folder.

## Recommended Next Tooling

- SwiftLint for style rules.
- SwiftFormat for consistent formatting.
- CI that runs build, test build, lint, and formatting checks.
