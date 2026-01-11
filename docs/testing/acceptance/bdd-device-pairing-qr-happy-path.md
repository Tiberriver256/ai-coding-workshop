# BDD Acceptance Evidence: Device Pairing QR Happy Path

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/device-pairing-qr.feature`
- Scenario: Pair using a QR code (happy path)

## Command
```
source .venv/bin/activate
behave tests/bdd/device-pairing-qr.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Pair a computer using QR onboarding # tests/bdd/device-pairing-qr.feature:1
  As a user
  I want to pair my computer with the mobile app using a QR code
  So that I can securely enable remote access
  Feature: Pair a computer using QR onboarding  # tests/bdd/device-pairing-qr.feature:1

  Scenario: Pair using a QR code (happy path)                   # tests/bdd/device-pairing-qr.feature:10
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:79
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:91
    When I run "unified auth login" on my computer              # tests/bdd/steps/device_pairing_steps.py:100
    And I choose the mobile QR pairing option                   # tests/bdd/steps/device_pairing_steps.py:106
    Then the CLI shows a QR code and a fallback connection link # tests/bdd/steps/device_pairing_steps.py:112
    When I scan the QR code in the mobile app                   # tests/bdd/steps/device_pairing_steps.py:119
    And I approve the pairing request                           # tests/bdd/steps/device_pairing_steps.py:125
    Then the computer is paired to my account                   # tests/bdd/steps/device_pairing_steps.py:136
    And the computer appears in the app's device list           # tests/bdd/steps/device_pairing_steps.py:143

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
9 steps passed, 0 failed, 0 skipped
Took 0min 0.005s
```

## Notes
- Validates CLI QR output, mobile pairing approval, and device list wiring in the web/mobile UI.
