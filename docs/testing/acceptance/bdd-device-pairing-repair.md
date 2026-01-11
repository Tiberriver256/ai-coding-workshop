# BDD Acceptance Evidence: Device Pairing Re-Authentication

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/device-pairing-qr.feature`
- Scenario: Re-pair a computer after forcing re-authentication

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
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:153
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:165
    When I run "unified auth login" on my computer              # tests/bdd/steps/device_pairing_steps.py:174
    And I choose the mobile QR pairing option                   # tests/bdd/steps/device_pairing_steps.py:180
    Then the CLI shows a QR code and a fallback connection link # tests/bdd/steps/device_pairing_steps.py:186
    When I scan the QR code in the mobile app                   # tests/bdd/steps/device_pairing_steps.py:193
    And I approve the pairing request                           # tests/bdd/steps/device_pairing_steps.py:231
    Then the computer is paired to my account                   # tests/bdd/steps/device_pairing_steps.py:253
    And the computer appears in the app's device list           # tests/bdd/steps/device_pairing_steps.py:266

  Scenario: Pair using a manual connection link       # tests/bdd/device-pairing-qr.feature:19
    Given I am signed in on the mobile app            # tests/bdd/steps/device_pairing_steps.py:153
    And the unified CLI is installed on my computer   # tests/bdd/steps/device_pairing_steps.py:165
    When I run "unified auth login" on my computer    # tests/bdd/steps/device_pairing_steps.py:174
    And I copy the connection link                    # tests/bdd/steps/device_pairing_steps.py:199
    And I paste the link into the mobile app          # tests/bdd/steps/device_pairing_steps.py:205
    And I approve the pairing request                 # tests/bdd/steps/device_pairing_steps.py:231
    Then the computer is paired to my account         # tests/bdd/steps/device_pairing_steps.py:253
    And the computer appears in the app's device list # tests/bdd/steps/device_pairing_steps.py:266

  Scenario: Reject a pairing request                      # tests/bdd/device-pairing-qr.feature:27
    Given I am signed in on the mobile app                # tests/bdd/steps/device_pairing_steps.py:153
    And the unified CLI is installed on my computer       # tests/bdd/steps/device_pairing_steps.py:165
    When I open a valid connection link in the mobile app # tests/bdd/steps/device_pairing_steps.py:217
    And I reject the pairing request                      # tests/bdd/steps/device_pairing_steps.py:242
    Then the computer is not paired to my account         # tests/bdd/steps/device_pairing_steps.py:260
    And the CLI shows that the request was rejected       # tests/bdd/steps/device_pairing_steps.py:291

  Scenario: Handle an invalid connection link                # tests/bdd/device-pairing-qr.feature:33
    Given I am signed in on the mobile app                   # tests/bdd/steps/device_pairing_steps.py:153
    And the unified CLI is installed on my computer          # tests/bdd/steps/device_pairing_steps.py:165
    When I open an invalid connection link in the mobile app # tests/bdd/steps/device_pairing_steps.py:224
    Then I see an invalid link message                       # tests/bdd/steps/device_pairing_steps.py:279
    And I cannot approve the pairing                         # tests/bdd/steps/device_pairing_steps.py:285

  Scenario: Re-pair a computer after forcing re-authentication  # tests/bdd/device-pairing-qr.feature:38
    Given I am signed in on the mobile app                      # tests/bdd/steps/device_pairing_steps.py:153
    And the unified CLI is installed on my computer             # tests/bdd/steps/device_pairing_steps.py:165
    Given my computer is already paired                         # tests/bdd/steps/device_pairing_steps.py:297
    When I run "unified auth login --force" on my computer      # tests/bdd/steps/device_pairing_steps.py:304
    And I approve the new pairing request on my phone           # tests/bdd/steps/device_pairing_steps.py:310
    Then the computer is re-paired                              # tests/bdd/steps/device_pairing_steps.py:317
    And the app shows the updated pairing status                # tests/bdd/steps/device_pairing_steps.py:323

1 feature passed, 0 failed, 0 skipped
5 scenarios passed, 0 failed, 0 skipped
35 steps passed, 0 failed, 0 skipped
Took 0min 0.018s
```

## Notes
- Covers the forced re-authentication flow and confirms the updated pairing status on the mobile UI.
