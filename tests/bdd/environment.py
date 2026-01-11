"""Behave environment configuration for BDD tests."""


def before_all(context):
    # Simple shared state container for step definitions.
    context.kanban_state = {
        "columns": [],
        "opened": False,
    }
    context.device_state = {}
