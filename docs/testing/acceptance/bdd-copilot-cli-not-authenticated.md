# BDD Acceptance Evidence: Copilot CLI Not Authenticated

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/copilot-cli-support.feature`
- Scenario: Copilot CLI is installed but not authenticated

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
    Given I am signed in to the product                  # tests/bdd/steps/copilot_cli_steps.py:175
    Given Copilot CLI is installed and authenticated     # tests/bdd/steps/copilot_cli_steps.py:182
    When I enable Copilot CLI in Settings                # tests/bdd/steps/copilot_cli_steps.py:190
    Then Copilot CLI is available as an assistant        # tests/bdd/steps/copilot_cli_steps.py:206
    And I can select it for task prompt autocomplete     # tests/bdd/steps/copilot_cli_steps.py:218

  Scenario: Use Copilot CLI to autocomplete a task prompt        # tests/bdd/copilot-cli-support.feature:15
    Given I am signed in to the product                          # tests/bdd/steps/copilot_cli_steps.py:175
    Given Copilot CLI is enabled                                 # tests/bdd/steps/copilot_cli_steps.py:228
    When I request autocomplete while writing a task description # tests/bdd/steps/copilot_cli_steps.py:239
    Then I see Copilot suggestions                               # tests/bdd/steps/copilot_cli_steps.py:250
    And I can insert a suggestion into the task description      # tests/bdd/steps/copilot_cli_steps.py:262

  Scenario: Copilot CLI is not installed           # tests/bdd/copilot-cli-support.feature:21
    Given I am signed in to the product            # tests/bdd/steps/copilot_cli_steps.py:175
    Given Copilot CLI is not installed             # tests/bdd/steps/copilot_cli_steps.py:270
    When I enable Copilot CLI in Settings          # tests/bdd/steps/copilot_cli_steps.py:190
    Then I see instructions to install Copilot CLI # tests/bdd/steps/copilot_cli_steps.py:286
    And Copilot CLI is not enabled                 # tests/bdd/steps/copilot_cli_steps.py:302

  Scenario: Copilot CLI is installed but not authenticated  # tests/bdd/copilot-cli-support.feature:27
    Given I am signed in to the product                     # tests/bdd/steps/copilot_cli_steps.py:175
    Given Copilot CLI is installed but not authenticated    # tests/bdd/steps/copilot_cli_steps.py:278
    When I enable Copilot CLI in Settings                   # tests/bdd/steps/copilot_cli_steps.py:190
    Then I see instructions to authenticate Copilot CLI     # tests/bdd/steps/copilot_cli_steps.py:294
    And Copilot CLI is not enabled                          # tests/bdd/steps/copilot_cli_steps.py:302

1 feature passed, 0 failed, 0 skipped
4 scenarios passed, 0 failed, 0 skipped
20 steps passed, 0 failed, 0 skipped
Took 0min 0.016s
```

## Notes
- Verified auth-required guidance in Settings and Copilot CLI remains disabled when authentication is missing.
