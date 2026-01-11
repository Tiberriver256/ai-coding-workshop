Feature: Organization management
  As a team owner or admin
  I want to manage organizations and members
  So that I can collaborate with my team

  Scenario: Create a new organization
    Given I am signed in
    When I open Organization Settings
    And I create an organization with a name and slug
    Then the organization is created
    And I can see it in the organization list

  Scenario: Invite a member with a role
    Given I am viewing an organization I manage
    When I invite a member by email with the "Admin" role
    Then the invitation is sent
    And the invitation appears in the pending invitations list

  Scenario: View members and pending invitations
    Given I am viewing an organization
    When I open the Members section
    Then I see a list of members and their roles
    And I can also view pending invitations

  Scenario: Remove a member
    Given I am an organization admin
    And a member is listed in the organization
    When I remove the member
    Then the member no longer appears in the member list

  Scenario: Delete an organization
    Given I am an organization admin
    When I choose to delete the organization
    And I confirm the deletion
    Then the organization is permanently removed

  Scenario: Login is required for organization management
    Given I am signed out
    When I open Organization Settings
    Then I am prompted to log in before managing organizations
