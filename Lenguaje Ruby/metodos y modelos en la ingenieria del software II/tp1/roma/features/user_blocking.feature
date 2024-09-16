Feature: Block account after wrong credentials
  In order to keep my account safe  
  As a user  
  I want my account to get blocked after three failed login tries

  Background:
    Given I am at the login page

  Scenario: 29.01 Account gets blocked
    When I try to login 3 times with wrong credentials  
    Then I should see an account blocked message

  Scenario: 29.02 Account is already blocked
    Given my account is blocked  
    When I try to login  
    Then I should see an account blocked message