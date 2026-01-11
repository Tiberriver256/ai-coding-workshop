Feature: File tree and changes panel
  As a user
  I want to browse files and view changes
  So that I can inspect the workspace quickly

  Scenario: Search files in the file tree
    Given a workspace is open
    When I type a query in the file search
    Then the file tree filters to matching files

  Scenario: Open a file from the file tree
    Given a workspace is open
    When I select a file in the file tree
    Then I can open it in my editor from the available actions

  Scenario: View changes in the changes panel
    Given a workspace has file changes
    When I open the Changes panel
    Then I see the list of modified files

  Scenario: No changes to display
    Given a workspace has no file changes
    When I open the Changes panel
    Then I see a message indicating there are no changes
