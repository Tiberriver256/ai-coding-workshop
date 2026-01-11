Feature: Debug log ingestion (optional)
  As a client app, I want to send debug logs to the server when logging is enabled.

  Scenario: Submit a debug log when the endpoint is enabled
    Given server-side logging ingestion is enabled
    When I POST /logs-combined-from-cli-and-mobile-for-simple-ai-debugging with a log payload
    Then the response indicates success

  Scenario: Logging endpoint is unavailable when disabled
    Given server-side logging ingestion is disabled
    When I POST /logs-combined-from-cli-and-mobile-for-simple-ai-debugging
    Then the response indicates the endpoint is not available
