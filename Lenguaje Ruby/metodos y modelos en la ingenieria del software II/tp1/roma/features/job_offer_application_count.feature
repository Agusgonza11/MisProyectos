Feature: Offers applicant count
  In order to know all the offers applicant  
  As a job offerer  
  I want to see the number of applicants of my offers

  Background:
    Given I am logged in as job offerer
    And only a "Programmer vacancy" offer exists in the offers list

  Scenario: 10.01 One application
    When a user applies to "Programmer vacancy" offer
    Then I should see 1 as the number of applicants

  Scenario: 10.02 No applications
    When no users apply to "Programmer vacancy" offer
    Then I should see 0 as the number of applicants

  Scenario: 10.03 Apply to offer with one application
    Given a user applies to "Programmer vacancy" offer
    When another user applies to "Programmer vacancy" offer
    Then I should see 2 as the number of applicants

  Scenario: 10.04 User tries to apply twice
    Given a user applies to "Programmer vacancy" offer
    When the same user applies to "Programmer vacancy" offer
    Then I should see 1 as the number of applicants