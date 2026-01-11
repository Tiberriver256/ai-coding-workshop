Feature: Configure Happy via environment variables
  Users can customize Happy behavior and storage locations using environment variables.

  Scenario: Use a custom Happy server URL
    Given I set the environment variable HAPPY_SERVER_URL
    When I run any Happy command
    Then Happy uses the custom server URL for API requests

  Scenario: Use a custom Happy web app URL
    Given I set the environment variable HAPPY_WEBAPP_URL
    When I start an authentication flow
    Then Happy uses the custom web app URL when generating web login links

  Scenario: Store Happy data in a custom directory
    Given I set the environment variable HAPPY_HOME_DIR to a custom path
    When I run a Happy command
    Then Happy stores settings and logs in that directory

  Scenario: Disable macOS sleep prevention
    Given I set HAPPY_DISABLE_CAFFEINATE to "true"
    When I start a Happy session
    Then Happy does not enable macOS sleep prevention

  Scenario: Enable experimental features
    Given I set HAPPY_EXPERIMENTAL to "true"
    When I run Happy
    Then Happy enables experimental features where available
