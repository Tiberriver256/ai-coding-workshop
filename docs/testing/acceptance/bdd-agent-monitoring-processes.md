# BDD Acceptance Evidence: Agent Monitoring Processes

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/agent-execution-monitoring.feature`
- Scenario: View all processes for an attempt

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
    Given a task attempt is running                          # tests/bdd/steps/agent_monitoring_steps.py:99
    When I open the task view                                # tests/bdd/steps/agent_monitoring_steps.py:108
    Then I see streaming logs of agent actions and responses # tests/bdd/steps/agent_monitoring_steps.py:118

  Scenario: View all processes for an attempt                 # tests/bdd/agent-execution-monitoring.feature:13
    Given a task attempt is running                           # tests/bdd/steps/agent_monitoring_steps.py:99
    When I open "View Processes"                              # tests/bdd/steps/agent_monitoring_steps.py:131
    Then I see a list of processes with status and timestamps # tests/bdd/steps/agent_monitoring_steps.py:141
    And I can open a process to view its logs                 # tests/bdd/steps/agent_monitoring_steps.py:153

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
7 steps passed, 0 failed, 0 skipped
Took 0min 0.007s
```

## Notes
- Confirms the task view process list UI, status/timestamp data, and process log drill-down.
