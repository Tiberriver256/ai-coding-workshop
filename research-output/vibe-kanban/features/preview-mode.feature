Feature: Preview mode and dev server controls
  As a user
  I want to preview my application inside Vibe Kanban
  So that I can test changes without leaving the app

  Scenario: Start a dev server and open preview
    Given a dev server script is configured
    When I click "Start Dev Server" in the Preview tab
    Then the dev server starts
    And the preview loads the detected URL in an embedded browser

  Scenario: Use preview toolbar controls
    Given a preview is running
    When I click Refresh, Copy URL, or Open in Browser
    Then the preview reloads, the URL is copied, or a browser tab opens

  Scenario: View dev server logs
    Given a dev server is running
    When I expand Dev Server Logs
    Then I see real-time output from the dev server

  Scenario: Stop the dev server
    Given a dev server is running
    When I click "Stop Dev Server"
    Then the server stops
    And the preview indicates it is no longer running

  Scenario: No dev script configured
    Given no dev server script is set for the project
    When I open the Preview tab
    Then I see a prompt to configure a dev server script
