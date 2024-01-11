Feature: Note Management

  Background:
    Given the following users exist:
    | email                       | confirmed_at           |
    | team_cluck_admin@gmail.com  | 2023-01-19 12:12:07.544080 |

    Given the following students exist:
    | firstname | lastname  | uin       | email                 | classification | major | teacher                    | last_practice_at              | curr_practice_interval |
    | John      | Doe      | 123456789 | john@example.com      | Freshman       | CS    | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 120                    |
    | Jane      | Smith    | 987654321 | jane@example.com      | Sophomore      | Math  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 240                    |

  Scenario: Create a new note for John
    When I sign in as "team_cluck_admin@gmail.com"
    And I visit the new note page for "John"
    And I fill in "This is a test note" for "Content"
    And I press "Add Note"
    Then I should see "Note was successfully created" from notes_steps
    And I should be on the student page for "John" from notes_steps

  Scenario: Create a new note for Jane
    When I sign in as "team_cluck_admin@gmail.com"
    And I visit the new note page for "Jane"
    And I fill in "This is another test note" for "Content"
    And I press "Add Note"
    Then I should see "Note was successfully created" from notes_steps
    And I should be on the student page for "Jane" from notes_steps
