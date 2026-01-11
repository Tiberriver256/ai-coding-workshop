Feature: App version update checks
  As a client app, I want to check whether an update is required for my platform.

  Scenario: iOS app is up to date
    Given the platform is "ios" and the version is current
    When I POST /v1/version with platform and version
    Then the response updateUrl is null

  Scenario: iOS app is out of date
    Given the platform is "ios" and the version is outdated
    When I POST /v1/version with platform and version
    Then the response updateUrl points to the iOS App Store

  Scenario: Android app is up to date
    Given the platform is "android" and the version is current
    When I POST /v1/version with platform and version
    Then the response updateUrl is null

  Scenario: Android app is out of date
    Given the platform is "android" and the version is outdated
    When I POST /v1/version with platform and version
    Then the response updateUrl points to Google Play

  Scenario: Unknown platform returns no update
    Given the platform is "desktop"
    When I POST /v1/version with platform and version
    Then the response updateUrl is null
