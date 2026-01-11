Feature: Support the app with a subscription
  As a user
  I want to support the app with a subscription
  So that I can contribute to its development

  Scenario: Open the support paywall
    Given I am on Settings
    And I do not have a Pro entitlement
    When I tap "Support Us"
    Then I see a paywall or purchase screen

  Scenario: Subscription succeeds
    Given I am viewing the support paywall
    When I complete a purchase
    Then I see a success state
    And the app reflects my Pro status

  Scenario: Subscription fails
    Given I am viewing the support paywall
    When the purchase fails
    Then I see an error message
    And my status remains unchanged
