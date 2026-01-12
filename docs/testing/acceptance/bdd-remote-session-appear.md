# BDD Acceptance Evidence: Remote Session Appears Remotely

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/remote-session-access.feature`
- Scenario: A session started on the computer appears remotely

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
    Given my computer is paired to my account                   # tests/bdd/steps/remote_session_steps.py:48
    When I start a new session on my computer                   # tests/bdd/steps/remote_session_steps.py:62
    Then the session appears in the mobile app sessions list    # tests/bdd/steps/remote_session_steps.py:74
    And the session appears in the web app sessions list        # tests/bdd/steps/remote_session_steps.py:84
    And the session shows as online                             # tests/bdd/steps/remote_session_steps.py:92

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
5 steps passed, 0 failed, 0 skipped
Took 0min 0.003s
```

## Notes
- Verified the desktop start-session control, shared sessions storage key, and web/mobile session list rendering with online status.
