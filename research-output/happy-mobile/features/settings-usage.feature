Feature: View usage analytics
  As a user
  I want to view usage statistics
  So that I can understand token and cost usage

  Scenario: View usage summary
    Given I am on Usage Settings
    When the data loads
    Then I see total tokens and total cost

  Scenario: Change usage period
    Given I am on Usage Settings
    When I select a different time period
    Then the charts and totals update for that period

  Scenario: Switch usage metric
    Given I am viewing the usage chart
    When I toggle between Tokens and Cost
    Then the chart updates to match the selected metric

  Scenario: Usage data fails to load
    Given I am on Usage Settings
    When the usage service is unavailable
    Then I see an error message
