Feature: Labels
  In order to get employees  
  As a job offerer  
  I want to add labels to my offers

  Background:
    Given I am logged in as job offerer

  Scenario: 39.01 Create new offer with label
    When I create a new offer with "java" as label  
    Then I should see "java" as label in my offers list

  Scenario: 39.02 Create new offer with multiple labels
    When I create a new offer with "Java , Python" as label
    Then I should see "java, python" as label in my offers list

  Scenario: 39.03 Update offer with label
    Given a offer with "java, python" as label
    When I update the label with "COBOL"  
    Then I should see "cobol" as label in my offers list