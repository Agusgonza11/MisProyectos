Feature: Notifications about user preferences
  In order to discover new interesting offers
  As a candidate
  I want to set my preferences and get notifications about new offers related to them

  Background:
    Given I am logged in

  Scenario: 16.01 Set preferences
    Given I am in my profile page
    When I change my preferences to "java"
    Then I should see a preferences updated message
    And I should see "java" as my preferences

  @wip
  Scenario: 16.02 Preferences match job offer labels
    Given I set my preferences to "java"
    When an offer "A job offer" with labels "java" is activated
    Then I should receive a notification mail with "A job offer"

  @wip
  Scenario: 16.03 One preference matched one label
    Given I set my preferences to "java, frontend, backend"
    When an offer "Another job offer" with labels "javascript, node, frontend" is activated
    Then I should receive a notification mail with "Another job offer"

  @wip
  Scenario: 16.04 No preference matched
    Given I set my preferences to "java, frontend, backend"
    When an offer "Not matching job offer" with labels "javascript, node" is activated
    Then I should not receive a notification mail with "Not matching job offer"