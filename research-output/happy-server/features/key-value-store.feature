Feature: User key-value store
  As an authenticated client, I want to store small encrypted values with version control.

  Background:
    Given I am an authenticated API client

  Scenario: Read an existing key
    Given a key "prefs/theme" exists with a value
    When I GET /v1/kv/prefs/theme
    Then the response includes the key, value, and version

  Scenario: Read a missing key returns not found
    Given no value exists for key "prefs/missing"
    When I GET /v1/kv/prefs/missing
    Then the response status is 404
    And the response contains a "Key not found" error

  Scenario: List keys by prefix
    Given I have keys under the prefix "prefs/"
    When I GET /v1/kv with prefix "prefs/" and limit 100
    Then the response includes only keys matching the prefix

  Scenario: Bulk get returns existing values only
    Given some requested keys are missing or deleted
    When I POST /v1/kv/bulk with a list of keys
    Then the response includes only keys that currently have values

  Scenario: Create a new key using version -1
    Given no key exists for "prefs/new-key"
    When I POST /v1/kv with a mutation for "prefs/new-key" using version -1
    Then the response indicates success
    And the new key has version 0

  Scenario: Delete a key by setting its value to null
    Given a key "prefs/obsolete" exists with version 4
    When I POST /v1/kv with a mutation for "prefs/obsolete" value null and version 4
    Then the response indicates success
    And the key no longer appears in GET or list results

  Scenario: Atomic batch mutation succeeds with correct versions
    Given I have the current versions for all keys in the batch
    When I POST /v1/kv with mutations that include matching versions
    Then the response indicates success
    And the response includes new versions for all mutated keys

  Scenario: Atomic batch mutation fails when any version is stale
    Given one key in the batch has a newer version than expected
    When I POST /v1/kv with mutations using the stale version
    Then the response status is 409
    And the response includes version-mismatch details for each failed key
