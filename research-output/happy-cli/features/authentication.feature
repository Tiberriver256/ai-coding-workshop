Feature: Authenticate and manage Happy credentials
  Users can authenticate with Happy, check status, and remove credentials.
  Authentication can be completed via mobile QR code or a web browser.

  Scenario: Show authentication help
    Given Happy CLI is installed
    When I run "happy auth --help"
    Then I see usage instructions for login, logout, and status

  Scenario: Log in using mobile authentication
    Given I am not authenticated with Happy
    When I run "happy auth login"
    And I choose the mobile authentication method
    Then Happy shows a QR code and a manual link for the mobile app
    And Happy waits until authentication completes
    And I see a success message with my machine ID

  Scenario: Log in using web authentication
    Given I am not authenticated with Happy
    When I run "happy auth login"
    And I choose the web authentication method
    Then Happy opens a browser to complete authentication
    And Happy displays the web URL in case the browser does not open
    And I see a success message when authentication completes

  Scenario: Cancel authentication from the selector
    Given I am not authenticated with Happy
    When I run "happy auth login"
    And I cancel the authentication method selection
    Then authentication is cancelled and the CLI exits

  Scenario: Login when already authenticated
    Given I am authenticated with Happy
    And my machine is already registered
    When I run "happy auth login"
    Then Happy tells me I am already authenticated
    And it does not start a new authentication flow

  Scenario: Force re-authentication
    Given I am authenticated with Happy
    And the Happy daemon may be running
    When I run "happy auth login --force"
    Then Happy clears my existing credentials and machine ID
    And Happy stops the daemon if it is running
    And Happy starts a new authentication flow

  Scenario: Check authentication status when not logged in
    Given I am not authenticated with Happy
    When I run "happy auth status"
    Then I see that I am not authenticated
    And I am prompted to run "happy auth login"

  Scenario: Check authentication status when logged in
    Given I am authenticated with Happy
    And my machine is registered
    When I run "happy auth status"
    Then I see that I am authenticated
    And I see a token preview and machine ID
    And I see the Happy data directory location

  Scenario: Log out with confirmation
    Given I am authenticated with Happy
    When I run "happy auth logout"
    And I confirm the logout prompt
    Then Happy removes my local Happy data
    And I see a message that I must re-authenticate to use Happy again

  Scenario: Cancel logout
    Given I am authenticated with Happy
    When I run "happy auth logout"
    And I decline the logout prompt
    Then I remain logged in

  Scenario: Use the deprecated logout command
    Given I am authenticated with Happy
    When I run "happy logout"
    Then Happy warns that the command is deprecated
    And Happy runs the same flow as "happy auth logout"

  Scenario: Authentication status when credentials exist but machine is missing
    Given I am authenticated with Happy
    And my machine is not registered
    When I run "happy auth status"
    Then I see a warning that the machine is not registered
    And I am instructed to run "happy auth login --force"
