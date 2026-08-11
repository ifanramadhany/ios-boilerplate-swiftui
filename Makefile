PROJECT ?= IOSBoilerplate.xcodeproj
APP_SCHEME ?= IOSBoilerplate
DEBUG_PRODUCTION_SCHEME ?= IOSBoilerplateDebugProduction
UNIT_TEST_SCHEME ?= IOSBoilerplateUnitTests
UI_TEST_SCHEME ?= IOSBoilerplateUITestsOnly
BUILD_DESTINATION ?= generic/platform=iOS Simulator
DEVICE_DESTINATION ?= generic/platform=iOS
TEST_DESTINATION ?= platform=iOS Simulator,name=iPhone 17
APP_DERIVED_DATA ?= /tmp/IOSBoilerplateAppDerivedData
TEST_DERIVED_DATA ?= /tmp/IOSBoilerplateTestDerivedData
XCODEBUILD ?= xcodebuild -project $(PROJECT) CODE_SIGNING_ALLOWED=NO
APP_XCODEBUILD = $(XCODEBUILD) -derivedDataPath $(APP_DERIVED_DATA)
TEST_XCODEBUILD = $(XCODEBUILD) -derivedDataPath $(TEST_DERIVED_DATA)

.PHONY: build debug-production-build device-build test test-build ui-test lint format format-check

build:
	$(APP_XCODEBUILD) -scheme $(APP_SCHEME) -destination '$(BUILD_DESTINATION)' build

debug-production-build:
	$(APP_XCODEBUILD) -scheme $(DEBUG_PRODUCTION_SCHEME) -destination '$(BUILD_DESTINATION)' build

device-build:
	$(APP_XCODEBUILD) -scheme $(APP_SCHEME) -destination '$(DEVICE_DESTINATION)' VALIDATE_PRODUCT=NO build

test:
	$(TEST_XCODEBUILD) -scheme $(UNIT_TEST_SCHEME) -destination '$(TEST_DESTINATION)' test

test-build:
	$(TEST_XCODEBUILD) -scheme $(UNIT_TEST_SCHEME) -destination '$(BUILD_DESTINATION)' build-for-testing

ui-test:
	$(TEST_XCODEBUILD) -scheme $(UI_TEST_SCHEME) -destination '$(TEST_DESTINATION)' test

lint:
	swiftlint lint --config .swiftlint.yml --cache-path /tmp/IOSBoilerplateSwiftLintCache

format:
	swiftformat IOSBoilerplate --config .swiftformat

format-check:
	swiftformat IOSBoilerplate --config .swiftformat --lint
