# BDD Acceptance Evidence: Agent Monitoring Stop

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/agent-execution-monitoring.feature`
- Scenario: Abort a running attempt

## Command
```
source .venv/bin/activate
behave tests/bdd/agent-execution-monitoring.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Agent execution monitoring # tests/bdd/agent-execution-monitoring.feature:1
  As a user
  I want to view live execution logs
  So that I can monitor agent progress
  Feature: Agent execution monitoring  # tests/bdd/agent-execution-monitoring.feature:1

  Scenario: View real-time execution logs                    # tests/bdd/agent-execution-monitoring.feature:9
    Given a task attempt is running                          # tests/bdd/steps/agent_monitoring_steps.py:114
    When I open the task view                                # tests/bdd/steps/agent_monitoring_steps.py:123
    Then I see streaming logs of agent actions and responses # tests/bdd/steps/agent_monitoring_steps.py:133

  Scenario: View all processes for an attempt                 # tests/bdd/agent-execution-monitoring.feature:13
    Given a task attempt is running                           # tests/bdd/steps/agent_monitoring_steps.py:114
    When I open "View Processes"                              # tests/bdd/steps/agent_monitoring_steps.py:146
    Then I see a list of processes with status and timestamps # tests/bdd/steps/agent_monitoring_steps.py:156
    And I can open a process to view its logs                 # tests/bdd/steps/agent_monitoring_steps.py:168

  Scenario: Abort a running attempt              # tests/bdd/agent-execution-monitoring.feature:18
    Given a task attempt is running              # tests/bdd/steps/agent_monitoring_steps.py:114
    When I click "Stop" on the task attempt      # tests/bdd/steps/agent_monitoring_steps.py:180
    Then the agent stops the current work        # tests/bdd/steps/agent_monitoring_steps.py:190
    And the attempt status changes to Stopped    # tests/bdd/steps/agent_monitoring_steps.py:196
    And evidence is recorded for the stop action # tests/bdd/steps/agent_monitoring_steps.py:203

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
12 steps passed, 0 failed, 0 skipped
Took 0min 0.009s
```

## Notes
- Confirms Stop button wiring, log stream halt, stopped status label, and evidence capture.
