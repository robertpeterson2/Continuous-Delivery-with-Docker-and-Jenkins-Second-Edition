Feature: Calculator
   Scenario: Sum two numbers
    Given I have two numbers: 1 and 2
    When the calculator sums them
    Then I receive 3 as a result
  Scenario: Divide two numbers
    Given I have two numbers: 10 and 2
    When the calculator divides them
    Then I receive 5 as a result
 