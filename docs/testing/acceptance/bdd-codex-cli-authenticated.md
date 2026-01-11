# BDD Acceptance Evidence: Codex CLI Authenticated Start

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/codex-cli-support.feature`
- Scenario: Start Codex mode when authenticated

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
    Given I am authenticated with the product         # tests/bdd/steps/codex_cli_steps.py:61
    When I run "unified codex"                        # tests/bdd/steps/codex_cli_steps.py:69
    Then a Codex session starts                       # tests/bdd/steps/codex_cli_steps.py:76
    And the session is connected for remote access    # tests/bdd/steps/codex_cli_steps.py:82

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
5 steps passed, 0 failed, 0 skipped
Took 0min 0.003s
```

## Notes
- Validates authenticated codex command wiring and connected session messaging.
