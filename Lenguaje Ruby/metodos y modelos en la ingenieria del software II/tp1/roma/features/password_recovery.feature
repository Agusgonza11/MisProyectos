Feature: Account recovery
  In order to get back my account
  As a user
  I want a mechanism to recover my password

  Background:
    Given I am at the login page
    And I have an account

  @wip
  Scenario: 36.01 Recovery code
    When I click recover password
    And I enter my email address
    Then I should get an email with a recovery code

  @wip
  Scenario: 36.02 Recover password
    Given I have a valid recovery code
    And I am at the recovery page
    When I enter the recovery code and email
    And I enter a new valid password
    Then I should be able to login

  @wip
  Scenario: 36.03 Inexistent user
    When I click recover password with an inexistent mail
    Then I should see a "Entered email is not registered in the system" message