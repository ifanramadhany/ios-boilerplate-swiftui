PROJECT = IOSBoilerplate.xcodeproj
APP_SCHEME = IOSBoilerplate
UNIT_TEST_SCHEME = IOSBoilerplateUnitTests
UI_TEST_SCHEME = IOSBoilerplateUITestsOnly
BUILD_DESTINATION = generic/platform=iOS Simulator
DEVICE_DESTINATION = generic/platform=iOS
TEST_DESTINATION = platform=iOS Simulator,name=iPhone 17,OS=26.5
DERIVED_DATA = /tmp/IOSBoilerplateDerivedData
XCODEBUILD = xcodebuild -project $(PROJECT) -derivedDataPath $(DERIVED_DATA) CODE_SIGNING_ALLOWED=NO

.PHONY: build device-build test test-build ui-test lint format format-check

build:
	$(XCODEBUILD) -scheme $(APP_SCHEME) -destination '$(BUILD_DESTINATION)' build

device-build:
	$(XCODEBUILD) -scheme $(APP_SCHEME) -destination '$(DEVICE_DESTINATION)' VALIDATE_PRODUCT=NO build

test:
	$(XCODEBUILD) -scheme $(UNIT_TEST_SCHEME) -destination '$(TEST_DESTINATION)' test

test-build:
	$(XCODEBUILD) -scheme $(UNIT_TEST_SCHEME) -destination '$(BUILD_DESTINATION)' build-for-testing

ui-test:
	$(XCODEBUILD) -scheme $(UI_TEST_SCHEME) -destination '$(TEST_DESTINATION)' test

lint:
	swiftlint lint --config .swiftlint.yml --cache-path /tmp/IOSBoilerplateSwiftLintCache

format:
	swiftformat IOSBoilerplate --config .swiftformat

format-check:
	swiftformat IOSBoilerplate --config .swiftformat --lint
