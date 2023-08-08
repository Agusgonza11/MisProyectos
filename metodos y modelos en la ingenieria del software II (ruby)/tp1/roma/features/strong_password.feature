Feature: Strong passwords
In order to satisfy my information security
As a user
I want the application to require strong passwords

  Scenario: 32.01 Register with strong password
    When I register with "Abcdefguio1" as the password
    Then I should see the message "User created"
  
  Scenario: 32.02 Register with short password
    When I register with "Abc1" as the password
    Then I should see the message "Password should be at least 10 characters long"

  Scenario: 32.03 Register without numbers in password
    When I register with "Abcdefguio" as the password
    Then I should see the message "Password should have at least 1 number"

  Scenario: 32.04 Register without uppercase character in password
    When I register with "abcdefguio1" as the password
    Then I should see the message "Password should have at least 1 uppercase character"

  Scenario: 32.05 Register without lowercase character in password
    When I register with "ADASASDFAS1" as the password
    Then I should see the message "Password should have at least 1 lowercase character"

  Scenario: 32.06 Register without lowercase character nor numbers in password
    When I register with "ADASASDFAS" as the password
    Then I should see the message "Password should have at least 1 lowercase character"
    And I should see the message "Password should have at least 1 number"