# BDD Acceptance Evidence: Device Pairing Invalid Link

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/device-pairing-qr.feature`
- Scenario: Handle an invalid connection link

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
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:127
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:139
    When I run "unified auth login" on my computer              # tests/bdd/steps/device_pairing_steps.py:148
    And I choose the mobile QR pairing option                   # tests/bdd/steps/device_pairing_steps.py:154
    Then the CLI shows a QR code and a fallback connection link # tests/bdd/steps/device_pairing_steps.py:160
    When I scan the QR code in the mobile app                   # tests/bdd/steps/device_pairing_steps.py:167
    And I approve the pairing request                           # tests/bdd/steps/device_pairing_steps.py:205
    Then the computer is paired to my account                   # tests/bdd/steps/device_pairing_steps.py:227
    And the computer appears in the app's device list           # tests/bdd/steps/device_pairing_steps.py:240

  Scenario: Pair using a manual connection link       # tests/bdd/device-pairing-qr.feature:19
    Given I am signed in on the mobile app            # tests/bdd/steps/device_pairing_steps.py:127
    And the unified CLI is installed on my computer   # tests/bdd/steps/device_pairing_steps.py:139
    When I run "unified auth login" on my computer    # tests/bdd/steps/device_pairing_steps.py:148
    And I copy the connection link                    # tests/bdd/steps/device_pairing_steps.py:173
    And I paste the link into the mobile app          # tests/bdd/steps/device_pairing_steps.py:179
    And I approve the pairing request                 # tests/bdd/steps/device_pairing_steps.py:205
    Then the computer is paired to my account         # tests/bdd/steps/device_pairing_steps.py:227
    And the computer appears in the app's device list # tests/bdd/steps/device_pairing_steps.py:240

  Scenario: Reject a pairing request                      # tests/bdd/device-pairing-qr.feature:27
    Given I am signed in on the mobile app                # tests/bdd/steps/device_pairing_steps.py:127
    And the unified CLI is installed on my computer       # tests/bdd/steps/device_pairing_steps.py:139
    When I open a valid connection link in the mobile app # tests/bdd/steps/device_pairing_steps.py:191
    And I reject the pairing request                      # tests/bdd/steps/device_pairing_steps.py:216
    Then the computer is not paired to my account         # tests/bdd/steps/device_pairing_steps.py:234
    And the CLI shows that the request was rejected       # tests/bdd/steps/device_pairing_steps.py:265

  Scenario: Handle an invalid connection link                # tests/bdd/device-pairing-qr.feature:33
    Given I am signed in on the mobile app                   # tests/bdd/steps/device_pairing_steps.py:127
    And the unified CLI is installed on my computer          # tests/bdd/steps/device_pairing_steps.py:139
    When I open an invalid connection link in the mobile app # tests/bdd/steps/device_pairing_steps.py:198
    Then I see an invalid link message                       # tests/bdd/steps/device_pairing_steps.py:253
    And I cannot approve the pairing                         # tests/bdd/steps/device_pairing_steps.py:259

1 feature passed, 0 failed, 0 skipped
4 scenarios passed, 0 failed, 0 skipped
28 steps passed, 0 failed, 0 skipped
Took 0min 0.016s
```

## Notes
- Invalid pairing links now surface an explicit error message and prevent approvals in the mobile UI.
