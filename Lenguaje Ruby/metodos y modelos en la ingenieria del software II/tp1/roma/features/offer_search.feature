Feature: Search offer
In order to find an offer
As a user
I want to search over all fields

  Background:
    Given there is an offer with "Backend developer" as the title
    And "Cordoba" as the location
    And "Java and python skills" as the description
    And "part-time" as labels
    And there is another offer with "Frontend developer" as the title
    And "Buenos Aires" as the location
    And "No experience needed" as the description
    And "full-time" as labels

  Scenario: 15.01 Search offer by title
    When I search an offer with "developer"
    Then I should see the offer "Backend developer"
    And I should see the offer "Frontend developer"

  Scenario: 15.02 Search offer by location
    When I search an offer with "cordoba"
    Then I should see the offer "Backend developer"

  Scenario: 15.03 Search offer by description
    When I search an offer with "EXP"
    Then I should see the offer "Frontend developer"

  Scenario: 15.04 Search offer by label
    When I search an offer with "part"
    Then I should see the offer "Backend developer"

  Scenario: 15.05 Search with two words
    When I search an offer with "backend frontend"
    Then I should see the offer "Backend developer"
    And I should see the offer "Frontend developer"
