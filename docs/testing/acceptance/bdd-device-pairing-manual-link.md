# BDD Acceptance Evidence: Device Pairing Manual Link

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/device-pairing-qr.feature`
- Scenario: Pair using a manual connection link

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
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:87
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:99
    When I run "unified auth login" on my computer              # tests/bdd/steps/device_pairing_steps.py:108
    And I choose the mobile QR pairing option                   # tests/bdd/steps/device_pairing_steps.py:114
    Then the CLI shows a QR code and a fallback connection link # tests/bdd/steps/device_pairing_steps.py:120
    When I scan the QR code in the mobile app                   # tests/bdd/steps/device_pairing_steps.py:127
    And I approve the pairing request                           # tests/bdd/steps/device_pairing_steps.py:151
    Then the computer is paired to my account                   # tests/bdd/steps/device_pairing_steps.py:162
    And the computer appears in the app's device list           # tests/bdd/steps/device_pairing_steps.py:169

  Scenario: Pair using a manual connection link       # tests/bdd/device-pairing-qr.feature:19
    Given I am signed in on the mobile app            # tests/bdd/steps/device_pairing_steps.py:87
    And the unified CLI is installed on my computer   # tests/bdd/steps/device_pairing_steps.py:99
    When I run "unified auth login" on my computer    # tests/bdd/steps/device_pairing_steps.py:108
    And I copy the connection link                    # tests/bdd/steps/device_pairing_steps.py:133
    And I paste the link into the mobile app          # tests/bdd/steps/device_pairing_steps.py:139
    And I approve the pairing request                 # tests/bdd/steps/device_pairing_steps.py:151
    Then the computer is paired to my account         # tests/bdd/steps/device_pairing_steps.py:162
    And the computer appears in the app's device list # tests/bdd/steps/device_pairing_steps.py:169

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
17 steps passed, 0 failed, 0 skipped
Took 0min 0.007s
```

## Notes
- Confirms manual link entry, approval flow, and device list wiring in the mobile app.
