Feature: Application with accounts
  In order to get valid applications  
  As a job offerer  
  I want the candidate's mail to be associated to an account

  Background:
    Given only a "Web Programmer" offer exists in the offers list

    Scenario: 48.01 Apply with a valid account
      Given I am logged in  
      And I access the offers list page  
      When I apply  
      Then I should see a application successful message

    Scenario: 48.02 Apply without an account
      Given I access the offers list page  
      When I apply  
      Then I should see a login required error message