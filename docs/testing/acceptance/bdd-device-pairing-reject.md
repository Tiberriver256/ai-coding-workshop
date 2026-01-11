# BDD Acceptance Evidence: Device Pairing Reject

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/device-pairing-qr.feature`
- Scenario: Reject a pairing request

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
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:110
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:122
    When I run "unified auth login" on my computer              # tests/bdd/steps/device_pairing_steps.py:131
    And I choose the mobile QR pairing option                   # tests/bdd/steps/device_pairing_steps.py:137
    Then the CLI shows a QR code and a fallback connection link # tests/bdd/steps/device_pairing_steps.py:143
    When I scan the QR code in the mobile app                   # tests/bdd/steps/device_pairing_steps.py:150
    And I approve the pairing request                           # tests/bdd/steps/device_pairing_steps.py:181
    Then the computer is paired to my account                   # tests/bdd/steps/device_pairing_steps.py:203
    And the computer appears in the app's device list           # tests/bdd/steps/device_pairing_steps.py:216

  Scenario: Pair using a manual connection link       # tests/bdd/device-pairing-qr.feature:19
    Given I am signed in on the mobile app            # tests/bdd/steps/device_pairing_steps.py:110
    And the unified CLI is installed on my computer   # tests/bdd/steps/device_pairing_steps.py:122
    When I run "unified auth login" on my computer    # tests/bdd/steps/device_pairing_steps.py:131
    And I copy the connection link                    # tests/bdd/steps/device_pairing_steps.py:156
    And I paste the link into the mobile app          # tests/bdd/steps/device_pairing_steps.py:162
    And I approve the pairing request                 # tests/bdd/steps/device_pairing_steps.py:181
    Then the computer is paired to my account         # tests/bdd/steps/device_pairing_steps.py:203
    And the computer appears in the app's device list # tests/bdd/steps/device_pairing_steps.py:216

  Scenario: Reject a pairing request                      # tests/bdd/device-pairing-qr.feature:27
    Given I am signed in on the mobile app                # tests/bdd/steps/device_pairing_steps.py:110
    And the unified CLI is installed on my computer       # tests/bdd/steps/device_pairing_steps.py:122
    When I open a valid connection link in the mobile app # tests/bdd/steps/device_pairing_steps.py:174
    And I reject the pairing request                      # tests/bdd/steps/device_pairing_steps.py:192
    Then the computer is not paired to my account         # tests/bdd/steps/device_pairing_steps.py:210
    And the CLI shows that the request was rejected       # tests/bdd/steps/device_pairing_steps.py:229

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
23 steps passed, 0 failed, 0 skipped
Took 0min 0.012s
```

## Notes
- Confirms rejection flow keeps the computer unpaired and surfaces rejection messaging in CLI and UI states.
