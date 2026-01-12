# BDD Acceptance Evidence: Mobile Start Session with Project Path

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/remote-session-access.feature`
- Scenario: Start a session in a chosen directory from the mobile app

## Command
```
source .venv/bin/activate
behave tests/bdd/remote-session-access.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Remote session access # tests/bdd/remote-session-access.feature:1
  As a user
  I want sessions started on my computer to appear remotely
  So that I can pick them up on mobile or the web
  Feature: Remote session access  # tests/bdd/remote-session-access.feature:1

  Scenario: A session started on the computer appears remotely  # tests/bdd/remote-session-access.feature:9
    Given my computer is paired to my account                   # tests/bdd/steps/remote_session_steps.py:57
    When I start a new session on my computer                   # tests/bdd/steps/remote_session_steps.py:71
    Then the session appears in the mobile app sessions list    # tests/bdd/steps/remote_session_steps.py:83
    And the session appears in the web app sessions list        # tests/bdd/steps/remote_session_steps.py:93
    And the session shows as online                             # tests/bdd/steps/remote_session_steps.py:101

  Scenario: Start a session in a chosen directory from the mobile app  # tests/bdd/remote-session-access.feature:15
    Given my computer is paired to my account                          # tests/bdd/steps/remote_session_steps.py:57
    Given I am viewing my computer in the mobile app                   # tests/bdd/steps/remote_session_steps.py:111
    When I enter a project path                                        # tests/bdd/steps/remote_session_steps.py:124
    And I start a new session                                          # tests/bdd/steps/remote_session_steps.py:133
    Then a new session is created on my computer                       # tests/bdd/steps/remote_session_steps.py:144
    And the session opens on my phone                                  # tests/bdd/steps/remote_session_steps.py:155

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
11 steps passed, 0 failed, 0 skipped
Took 0min 0.006s
```

## Notes
- Verified the mobile project path input, session creation wiring, active session view, and shared sessions storage.
