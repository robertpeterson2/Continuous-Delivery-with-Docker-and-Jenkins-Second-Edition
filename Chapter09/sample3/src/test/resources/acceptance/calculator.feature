Feature: Calculator
  Scenario: Divide two numbers
    Given I have two numbers: 10 and 2
    When the calculator divides them
    Then I receive 4 as a result