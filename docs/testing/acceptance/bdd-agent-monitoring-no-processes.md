# BDD Acceptance Evidence: Agent Monitoring No Processes

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/agent-execution-monitoring.feature`
- Scenario: No processes available

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
    Given a task attempt is running                          # tests/bdd/steps/agent_monitoring_steps.py:122
    When I open the task view                                # tests/bdd/steps/agent_monitoring_steps.py:140
    Then I see streaming logs of agent actions and responses # tests/bdd/steps/agent_monitoring_steps.py:150

  Scenario: View all processes for an attempt                 # tests/bdd/agent-execution-monitoring.feature:13
    Given a task attempt is running                           # tests/bdd/steps/agent_monitoring_steps.py:122
    When I open "View Processes"                              # tests/bdd/steps/agent_monitoring_steps.py:163
    Then I see a list of processes with status and timestamps # tests/bdd/steps/agent_monitoring_steps.py:173
    And I can open a process to view its logs                 # tests/bdd/steps/agent_monitoring_steps.py:185

  Scenario: Abort a running attempt              # tests/bdd/agent-execution-monitoring.feature:18
    Given a task attempt is running              # tests/bdd/steps/agent_monitoring_steps.py:122
    When I click "Stop" on the task attempt      # tests/bdd/steps/agent_monitoring_steps.py:203
    Then the agent stops the current work        # tests/bdd/steps/agent_monitoring_steps.py:213
    And the attempt status changes to Stopped    # tests/bdd/steps/agent_monitoring_steps.py:219
    And evidence is recorded for the stop action # tests/bdd/steps/agent_monitoring_steps.py:226

  Scenario: No processes available                             # tests/bdd/agent-execution-monitoring.feature:24
    Given a task attempt is running                            # tests/bdd/steps/agent_monitoring_steps.py:122
    Given the attempt has no processes                         # tests/bdd/steps/agent_monitoring_steps.py:131
    When I open "View Processes"                               # tests/bdd/steps/agent_monitoring_steps.py:163
    Then I see a message indicating no processes are available # tests/bdd/steps/agent_monitoring_steps.py:197

1 feature passed, 0 failed, 0 skipped
4 scenarios passed, 0 failed, 0 skipped
16 steps passed, 0 failed, 0 skipped
Took 0min 0.011s
```

## Notes
- Confirms the process panel surfaces a no-processes empty-state message.
