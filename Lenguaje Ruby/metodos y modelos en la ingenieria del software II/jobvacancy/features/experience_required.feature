Feature: Indicate necessary experience in Job Offer
  In order to get experience employees 
  As a job offerer
  I want to be able to indicate the necessary experience

  Background:
      Given I am logged in as job offerer

  Scenario: The required experience is an integer
    When I create a new offer with "Programmer vacancy" as the title and 10 as the required experience
    Then I should see a offer created confirmation message
    And I should see "Programmer vacancy" in my offers list

  Scenario: The required experience is a negative number
    When I create a new offer with "Programmer vacancy" as the title and -5 as the required experience
    Then I should see a invalid required experience message, must be positive

  Scenario: The required experience is a float number
    When I create a new offer with "Programmer vacancy" as the title and 2.5 as the experience required
    Then I should see a invalid required experience message, must be an integer

  @wip
  Scenario: The required experience is zero
    When I create a new offer with "Programmer vacancy" as the title and 0 as the experience required
    Then I should see a offer created confirmation message
    And I should see "Programmer vacancy" in my offers list
    And I should see "Not specified" in experience required field


