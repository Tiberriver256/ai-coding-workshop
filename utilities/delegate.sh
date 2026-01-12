#!/bin/bash

# delegate.sh - A utility script to delegate tasks to the codex AI agent
# Runs tasks in tmux sessions for reliable background execution
# Logs are saved to /tmp/delegate-logs/ for recovery and searching

set -e

# Script directory for finding common-roles
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_ROLES_DIR="$SCRIPT_DIR/common-roles"
LIB_DIR="$SCRIPT_DIR/lib"

# Default values
ROLE=""
GOAL=""
ACCEPTANCE_CRITERIA=""
THE_WHY=""
TASK_DETAIL=""
LOG_DIR="/tmp/delegate-logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FOREGROUND=false  # Run in tmux by default

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

for module in "$LIB_DIR/delegate-sessions.sh" "$LIB_DIR/delegate-roles.sh" "$LIB_DIR/delegate-prompt.sh"; do
    if [[ -f "$module" ]]; then
        # shellcheck source=/dev/null
        source "$module"
    else
        echo -e "${RED}Error: Missing delegate module: $module${NC}" >&2
        exit 1
    fi
done

show_help() {
    cat << EOF
${GREEN}delegate.sh${NC} - Delegate tasks to the codex AI agent

${YELLOW}USAGE:${NC}
    delegate.sh [OPTIONS]

${YELLOW}OPTIONS:${NC}
    -r, --role <text>               Role description of the ideal person for this task
    -c, --common-role <name>        Use a predefined role from common-roles/<name>.md
    -g, --goal <text>               The goal/objective of the task
    -a, --acceptance-criteria <text> Acceptance criteria for task completion
    -w, --why <text>                The reasoning behind the task
    -t, --task-detail <text>        Detailed task description
    -n, --name <text>               Task name (used for tmux session and log filenames)
    -f, --foreground                Run in foreground instead of tmux session
    -l, --list-roles                List available common roles
    -s, --status [name]             Check status of running delegate sessions
    --check <name>                  Quick check if a session is running or done
    --check-all                     Quick check status of all delegate sessions
    --clean                         Kill all idle tmux sessions (task complete, waiting on read)
    --clean-all                     Kill ALL delegate tmux sessions (including running ones)
    --purge [name]                  Kill session(s) AND delete their log files
    -k, --kill <name>               Kill a running delegate session
    --continue <name> <message>     Send a follow-up message to an existing session
    -h, --help                      Show this help message

${YELLOW}EXAMPLES:${NC}
    # Simple task (runs in tmux background)
    delegate.sh -r "Software developer" -g "Create a hello world file" \\
                -t "Create hello-world.md with 'Hello World' content" -n "hello"

    # Using a common role
    delegate.sh -c feature-analyst -g "Extract features from auth module" \\
                -t "Create .feature files for /src/auth" -n "auth-features"

    # Run in foreground (blocks until complete)
    delegate.sh -f -c architect -g "Quick documentation task" -t "..."

    # Check status of all running tasks
    delegate.sh --status

    # Quick check if a task is done
    delegate.sh --check my-task

    # Quick check all tasks
    delegate.sh --check-all

    # Send follow-up message to continue conversation
    delegate.sh --continue my-task "Now also add unit tests for that feature"

    # Kill a running task
    delegate.sh --kill my-task

    # Clean up idle sessions (completed tasks still open)
    delegate.sh --clean

    # Kill ALL delegate sessions (including running)
    delegate.sh --clean-all

    # Delete a session and its logs completely
    delegate.sh --purge my-task

    # Delete ALL sessions and logs
    delegate.sh --purge

${YELLOW}COMMON ROLES:${NC}
    Available in: ${COMMON_ROLES_DIR}/
    List with: delegate.sh --list-roles

${YELLOW}LOGS:${NC}
    Logs are saved to: ${LOG_DIR}/
    - stdout (agent comms): <timestamp>_<name>_stdout.log
    - stderr (verbose/debug): <timestamp>_<name>_stderr.log

${YELLOW}TMUX SESSION MANAGEMENT:${NC}
    Tasks run in tmux sessions prefixed with 'delegate-'
    - List sessions:  tmux list-sessions | grep delegate
    - Attach:         tmux attach -t delegate-<name>
    - Detach:         Ctrl+B, then D
    - Kill:           delegate.sh --kill <name>

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--role)
            ROLE="$2"
            shift 2
            ;;
        -c|--common-role)
            ROLE=$(load_common_role "$2")
            shift 2
            ;;
        -g|--goal)
            GOAL="$2"
            shift 2
            ;;
        -a|--acceptance-criteria)
            ACCEPTANCE_CRITERIA="$2"
            shift 2
            ;;
        -w|--why)
            THE_WHY="$2"
            shift 2
            ;;
        -t|--task-detail)
            TASK_DETAIL="$2"
            shift 2
            ;;
        -n|--name)
            TASK_NAME="$2"
            shift 2
            ;;
        -f|--foreground)
            FOREGROUND=true
            shift
            ;;
        -l|--list-roles)
            list_roles
            exit 0
            ;;
        -s|--status)
            if [[ -n "$2" && "$2" != -* ]]; then
                show_status "$2"
                shift 2
            else
                show_status ""
                shift
            fi
            exit 0
            ;;
        -k|--kill)
            kill_session "$2"
            shift 2
            exit 0
            ;;
        --check)
            check_session "$2"
            shift 2
            exit 0
            ;;
        --check-all)
            check_all_sessions
            shift
            exit 0
            ;;
        --clean)
            clean_sessions "false"
            shift
            exit 0
            ;;
        --clean-all)
            clean_sessions "true"
            shift
            exit 0
            ;;
        --purge)
            if [[ -n "$2" && "$2" != -* ]]; then
                purge_session "$2"
                shift 2
            else
                purge_session ""
                shift
            fi
            exit 0
            ;;
        --continue)
            continue_session "$2" "$3"
            shift 3
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Validate required fields
if [[ -z "$GOAL" && -z "$TASK_DETAIL" ]]; then
    echo -e "${RED}Error: At least --goal or --task-detail must be provided${NC}"
    show_help
    exit 1
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Generate log filenames
TASK_NAME="${TASK_NAME:-task}"
TASK_NAME_SAFE=$(echo "$TASK_NAME" | tr ' ' '_' | tr -cd '[:alnum:]_-')
STDOUT_LOG="${LOG_DIR}/${TIMESTAMP}_${TASK_NAME_SAFE}_stdout.log"
STDERR_LOG="${LOG_DIR}/${TIMESTAMP}_${TASK_NAME_SAFE}_stderr.log"
SESSION_NAME="delegate-${TASK_NAME_SAFE}"

# Check for existing session with same name
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${RED}Error: Session '$SESSION_NAME' already exists${NC}"
    echo -e "Either:"
    echo -e "  - Use a different name: -n different-name"
    echo -e "  - Kill the existing session: delegate.sh --kill $TASK_NAME_SAFE"
    echo -e "  - Check its status: delegate.sh --status $TASK_NAME_SAFE"
    exit 1
fi

PROMPT=$(build_prompt)

# Save prompt to a temp file for tmux to read
PROMPT_FILE="${LOG_DIR}/${TIMESTAMP}_${TASK_NAME_SAFE}_prompt.txt"
echo "$PROMPT" > "$PROMPT_FILE"

if [[ "$FOREGROUND" == true ]]; then
    # Run in foreground (original behavior)
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Running task in foreground${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Logs:${NC}"
    echo -e "  stdout: ${STDOUT_LOG}"
    echo -e "  stderr: ${STDERR_LOG}"
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}Prompt being sent:${NC}"
    echo "$PROMPT"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

    # Execute codex with the prompt
    cat "$PROMPT_FILE" | codex exec --yolo 2> >(tee "$STDERR_LOG" >&2) | tee "$STDOUT_LOG"
    EXIT_CODE=${PIPESTATUS[0]}

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    if [[ $EXIT_CODE -eq 0 ]]; then
        echo -e "${GREEN}Task completed successfully${NC}"
    else
        echo -e "${RED}Task failed with exit code: $EXIT_CODE${NC}"
    fi
    echo -e "${YELLOW}Logs saved to:${NC}"
    echo -e "  stdout: ${STDOUT_LOG}"
    echo -e "  stderr: ${STDERR_LOG}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    exit $EXIT_CODE
else
    # Run in tmux session (default)
    
    # Create the command to run inside tmux
    TMUX_CMD="cat '$PROMPT_FILE' | codex exec --yolo 2> >(tee '$STDERR_LOG' >&2) | tee '$STDOUT_LOG'; echo ''; echo 'Task completed. Press Enter to close session or Ctrl+C to keep it open.'; read"
    
    # Start tmux session
    tmux new-session -d -s "$SESSION_NAME" "bash -c \"$TMUX_CMD\""
    
    # Output session info
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Task delegated to tmux session${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Session:${NC}  $SESSION_NAME"
    echo -e "${YELLOW}Task:${NC}     ${GOAL:-$TASK_DETAIL}"
    echo ""
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}Logs:${NC}"
    echo -e "  stdout: ${STDOUT_LOG}"
    echo -e "  stderr: ${STDERR_LOG}"
    echo -e "  prompt: ${PROMPT_FILE}"
    echo ""
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}Commands:${NC}"
    echo ""
    echo -e "  ${GREEN}# Attach to watch live:${NC}"
    echo -e "  tmux attach -t $SESSION_NAME"
    echo ""
    echo -e "  ${GREEN}# Tail the logs:${NC}"
    echo -e "  tail -f $STDERR_LOG"
    echo ""
    echo -e "  ${GREEN}# Check if still running:${NC}"
    echo -e "  tmux has-session -t $SESSION_NAME 2>/dev/null && echo 'Running' || echo 'Done'"
    echo ""
    echo -e "  ${GREEN}# View all delegate sessions:${NC}"
    echo -e "  delegate.sh --status"
    echo ""
    echo -e "  ${GREEN}# Kill this session:${NC}"
    echo -e "  delegate.sh --kill $TASK_NAME_SAFE"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
fi
