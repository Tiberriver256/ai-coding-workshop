# BDD Acceptance Evidence: Codex CLI Auth Prompt

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/codex-cli-support.feature`
- Scenario: Prompt for authentication before starting Codex

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
    Given I am authenticated with the product         # tests/bdd/steps/codex_cli_steps.py:94
    When I run "unified codex"                        # tests/bdd/steps/codex_cli_steps.py:111
    Then a Codex session starts                       # tests/bdd/steps/codex_cli_steps.py:118
    And the session is connected for remote access    # tests/bdd/steps/codex_cli_steps.py:124

  Scenario: Prompt for authentication before starting Codex     # tests/bdd/codex-cli-support.feature:15
    Given the unified CLI is installed on my computer           # tests/bdd/steps/device_pairing_steps.py:165
    Given I am not authenticated with the product               # tests/bdd/steps/codex_cli_steps.py:102
    When I run "unified codex"                                  # tests/bdd/steps/codex_cli_steps.py:111
    Then the product starts the authentication flow             # tests/bdd/steps/codex_cli_steps.py:130
    And the Codex session starts after authentication completes # tests/bdd/steps/codex_cli_steps.py:137

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
10 steps passed, 0 failed, 0 skipped
Took 0min 0.005s
```

## Notes
- Validates unauthenticated Codex invocation triggers auth flow and starts after completion.
