Feature: Project scripts and file copying
  As a user
  I want to configure project scripts and copied files
  So that task attempts run in a prepared environment

  Scenario: Configure a setup script
    Given I am viewing project settings
    When I set a setup script (e.g., install dependencies)
    Then the script runs automatically before each task attempt

  Scenario: Configure a dev server script
    Given I am viewing project settings
    When I set a dev server script
    Then I can start the dev server from the Preview section

  Scenario: Configure a cleanup script
    Given I am viewing project settings
    When I set a cleanup script
    Then the script runs after each agent turn completes

  Scenario: Configure files to copy into worktrees
    Given I am viewing project settings
    When I list files or glob patterns to copy
    Then those files are copied into each task worktree before setup runs

  Scenario: Copying non-gitignored files warns the user
    Given I add a file to the copy list
    When that file is not gitignored in the repository
    Then I am warned that it could be committed accidentally
