# BDD Acceptance Evidence: Copilot CLI Autocomplete

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/copilot-cli-support.feature`
- Scenario: Use Copilot CLI to autocomplete a task prompt

## Command
```
source .venv/bin/activate
behave tests/bdd/copilot-cli-support.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Copilot CLI support for command and prompt suggestions # tests/bdd/copilot-cli-support.feature:1
  As a user
  I want to use Copilot CLI as an assistant
  So that I can get autocomplete suggestions while working on tasks
  Feature: Copilot CLI support for command and prompt suggestions  # tests/bdd/copilot-cli-support.feature:1

  Scenario: Enable Copilot CLI integration (happy path)  # tests/bdd/copilot-cli-support.feature:9
    Given I am signed in to the product                  # tests/bdd/steps/copilot_cli_steps.py:154
    Given Copilot CLI is installed and authenticated     # tests/bdd/steps/copilot_cli_steps.py:161
    When I enable Copilot CLI in Settings                # tests/bdd/steps/copilot_cli_steps.py:169
    Then Copilot CLI is available as an assistant        # tests/bdd/steps/copilot_cli_steps.py:183
    And I can select it for task prompt autocomplete     # tests/bdd/steps/copilot_cli_steps.py:195

  Scenario: Use Copilot CLI to autocomplete a task prompt        # tests/bdd/copilot-cli-support.feature:15
    Given I am signed in to the product                          # tests/bdd/steps/copilot_cli_steps.py:154
    Given Copilot CLI is enabled                                 # tests/bdd/steps/copilot_cli_steps.py:205
    When I request autocomplete while writing a task description # tests/bdd/steps/copilot_cli_steps.py:216
    Then I see Copilot suggestions                               # tests/bdd/steps/copilot_cli_steps.py:227
    And I can insert a suggestion into the task description      # tests/bdd/steps/copilot_cli_steps.py:239

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
10 steps passed, 0 failed, 0 skipped
Took 0min 0.013s
```

## Notes
- Steps validate Copilot suggestion templates, request wiring, and insertion behavior in the task modal.
