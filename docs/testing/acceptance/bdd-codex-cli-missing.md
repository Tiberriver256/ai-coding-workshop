# BDD Acceptance Evidence: Codex CLI Missing

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/codex-cli-support.feature`
- Scenario: Codex CLI is not installed locally

## Command
```
source .venv/bin/activate
behave tests/bdd/codex-cli-support.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Codex CLI support for remote sessions # tests/bdd/codex-cli-support.feature:1
  As a user
  I want to start Codex CLI sessions through the product
  So that I can use Codex with remote access and orchestration
  Feature: Codex CLI support for remote sessions  # tests/bdd/codex-cli-support.feature:1

  Scenario: Start Codex mode when authenticated       # tests/bdd/codex-cli-support.feature:9
    Given the unified CLI is installed on my computer # tests/bdd/steps/device_pairing_steps.py:165
    Given I am authenticated with the product         # tests/bdd/steps/codex_cli_steps.py:126
    When I run "unified codex"                        # tests/bdd/steps/codex_cli_steps.py:151
    Then a Codex session starts                       # tests/bdd/steps/codex_cli_steps.py:158
    And the session is connected for remote access    # tests/bdd/steps/codex_cli_steps.py:164

  Scenario: Prompt for authentication before starting Codex     # tests/bdd/codex-cli-support.feature:15
    Given the unified CLI is installed on my computer           # tests/bdd/steps/device_pairing_steps.py:165
    Given I am not authenticated with the product               # tests/bdd/steps/codex_cli_steps.py:134
    When I run "unified codex"                                  # tests/bdd/steps/codex_cli_steps.py:151
    Then the product starts the authentication flow             # tests/bdd/steps/codex_cli_steps.py:170
    And the Codex session starts after authentication completes # tests/bdd/steps/codex_cli_steps.py:177

  Scenario: Codex CLI is not installed locally           # tests/bdd/codex-cli-support.feature:21
    Given the unified CLI is installed on my computer    # tests/bdd/steps/device_pairing_steps.py:165
    Given I am authenticated with the product            # tests/bdd/steps/codex_cli_steps.py:126
    And Codex CLI is not installed                       # tests/bdd/steps/codex_cli_steps.py:143
    When I run "unified codex"                           # tests/bdd/steps/codex_cli_steps.py:151
    Then I see an error indicating Codex CLI is required # tests/bdd/steps/codex_cli_steps.py:186
    And the session does not start                       # tests/bdd/steps/codex_cli_steps.py:192

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
16 steps passed, 0 failed, 0 skipped
Took 0min 0.007s
```

## Notes
- Confirms missing Codex CLI guard prevents session start and reports the required error.
