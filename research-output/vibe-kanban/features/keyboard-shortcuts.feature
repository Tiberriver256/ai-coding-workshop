Feature: Keyboard shortcuts
  As a power user
  I want keyboard shortcuts for common actions
  So that I can work efficiently

  Scenario: Create a task with the keyboard
    Given I am on a project board
    When I press "C"
    Then the Create Task dialog opens

  Scenario: Focus search
    Given I am anywhere in the app
    When I press "Ctrl+S" or "Cmd+S"
    Then the search input is focused

  Scenario: Navigate the board with the keyboard
    Given a task card is focused
    When I press "j" or "k"
    Then focus moves down or up within the column
    When I press "h" or "l"
    Then focus moves to the nearest task in the adjacent column

  Scenario: Open and delete a focused task
    Given a task card is focused
    When I press "Enter"
    Then the task details open
    When I press "d"
    Then the task is deleted

  Scenario: Send a message to the agent
    Given I am composing a follow-up message
    When I press "Ctrl+Enter" or "Cmd+Enter"
    Then the message is sent to the agent

  Scenario: Escape cancels editing
    Given I am editing a draft or comment
    When I press "Escape"
    Then the edit is cancelled or cleared
