Feature: codevs starts game

  As a codevs
  block is holl.

  Scenario: start game
    Given I am not yet playing
    When I start a new game
    Then Game stage is created
