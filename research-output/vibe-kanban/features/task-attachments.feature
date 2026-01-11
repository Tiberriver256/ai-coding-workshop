Feature: Task image attachments
  As a user
  I want to attach images to tasks
  So that I can provide visual context

  Scenario: Attach an image while creating a task
    Given I am creating a new task
    When I attach an image file
    Then the image is uploaded
    And a reference to the image appears in the task description

  Scenario: Drag and drop images into the task form
    Given I am creating or editing a task
    When I drop one or more image files into the form
    Then those images are uploaded and attached

  Scenario: Existing images appear when editing
    Given a task already has image attachments
    When I open the task for editing
    Then I can see the existing attached images in the editor
