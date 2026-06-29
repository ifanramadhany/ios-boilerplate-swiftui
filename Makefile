PROJECT = IOSBoilerplate.xcodeproj
SCHEME = IOSBoilerplate
DESTINATION = generic/platform=iOS
DERIVED_DATA = /tmp/IOSBoilerplateDerivedData

.PHONY: build test-build lint format format-check

build:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination $(DESTINATION) -derivedDataPath $(DERIVED_DATA) CODE_SIGNING_ALLOWED=NO build

test-build:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination $(DESTINATION) -derivedDataPath $(DERIVED_DATA) CODE_SIGNING_ALLOWED=NO build-for-testing

lint:
	swiftlint lint --config .swiftlint.yml --cache-path /tmp/IOSBoilerplateSwiftLintCache

format:
	swiftformat IOSBoilerplate --config .swiftformat

format-check:
	swiftformat IOSBoilerplate --config .swiftformat --lint
