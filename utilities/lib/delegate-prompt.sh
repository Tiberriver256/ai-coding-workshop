# Prompt construction helper for delegate.sh

build_prompt() {
    local prompt=""

    if [[ -n "$ROLE" ]]; then
        prompt+="<role>
$ROLE
</role>
"
    fi

    prompt+="<task>
"

    if [[ -n "$GOAL" ]]; then
        prompt+="  <goal>$GOAL</goal>
"
    fi

    if [[ -n "$ACCEPTANCE_CRITERIA" ]]; then
        prompt+="  <acceptanceCriteria>$ACCEPTANCE_CRITERIA</acceptanceCriteria>
"
    fi

    if [[ -n "$THE_WHY" ]]; then
        prompt+="  <theWhy>$THE_WHY</theWhy>
"
    fi

    if [[ -n "$TASK_DETAIL" ]]; then
        prompt+="  <taskDetail>$TASK_DETAIL</taskDetail>
"
    fi

    prompt+="</task>"

    echo "$prompt"
}
