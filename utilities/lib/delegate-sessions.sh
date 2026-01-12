# Session management helpers for delegate.sh

show_status() {
    local filter="$1"
    echo -e "${GREEN}Delegate Sessions${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

    local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep "^delegate-" || true)

    if [[ -z "$sessions" ]]; then
        echo -e "${YELLOW}No active delegate sessions${NC}"
        echo ""
        echo -e "Recent logs in ${LOG_DIR}/:"
        ls -lt "$LOG_DIR"/*.log 2>/dev/null | head -10 | awk '{print "  " $NF}' || echo "  (no logs found)"
        return 0
    fi

    for session in $sessions; do
        local name="${session#delegate-}"
        if [[ -n "$filter" && "$name" != *"$filter"* ]]; then
            continue
        fi

        echo -e "${YELLOW}Session:${NC} $name"

        # Find matching log files
        local log_pattern="${LOG_DIR}/*_${name}_*.log"
        local stdout_log=$(ls -t ${LOG_DIR}/*_${name}_stdout.log 2>/dev/null | head -1)
        local stderr_log=$(ls -t ${LOG_DIR}/*_${name}_stderr.log 2>/dev/null | head -1)

        if [[ -n "$stdout_log" ]]; then
            echo -e "  ${BLUE}stdout:${NC} $stdout_log"
        fi
        if [[ -n "$stderr_log" ]]; then
            echo -e "  ${BLUE}stderr:${NC} $stderr_log"
        fi

        echo -e "  ${BLUE}Commands:${NC}"
        echo -e "    Attach:  tmux attach -t $session"
        echo -e "    Kill:    delegate.sh --kill $name"
        if [[ -n "$stderr_log" ]]; then
            echo -e "    Tail:    tail -f $stderr_log"
        fi
        echo ""
    done
}

kill_session() {
    local name="$1"
    local session="delegate-$name"

    if tmux has-session -t "$session" 2>/dev/null; then
        tmux kill-session -t "$session"
        echo -e "${GREEN}Killed session:${NC} $session"
    else
        echo -e "${RED}Session not found:${NC} $session"
        echo -e "Active sessions:"
        tmux list-sessions -F '#{session_name}' 2>/dev/null | grep "^delegate-" | sed 's/^delegate-/  /' || echo "  (none)"
        exit 1
    fi
}

clean_sessions() {
    local kill_running="$1"
    local killed=0
    local skipped=0

    local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep "^delegate-" || true)

    if [[ -z "$sessions" ]]; then
        echo -e "${YELLOW}No delegate sessions to clean${NC}"
        return 0
    fi

    for session in $sessions; do
        local name="${session#delegate-}"
        local pane_pid=$(tmux list-panes -t "$session" -F '#{pane_pid}' 2>/dev/null)
        local children=$(ps --ppid "$pane_pid" -o comm= 2>/dev/null | grep -v '^$' | wc -l)

        if [[ "$children" -gt 0 ]]; then
            # Session is running
            if [[ "$kill_running" == "true" ]]; then
                tmux kill-session -t "$session" 2>/dev/null
                echo -e "${RED}Killed running:${NC} $name"
                killed=$((killed + 1))
            else
                echo -e "${YELLOW}Skipped running:${NC} $name"
                skipped=$((skipped + 1))
            fi
        else
            # Session is idle
            tmux kill-session -t "$session" 2>/dev/null
            echo -e "${GREEN}Killed idle:${NC} $name"
            killed=$((killed + 1))
        fi
    done

    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "Cleaned: ${GREEN}$killed killed${NC}, ${YELLOW}$skipped skipped${NC}"
}

purge_session() {
    local name="$1"

    if [[ -z "$name" ]]; then
        # Purge ALL sessions and logs
        echo -e "${RED}⚠️  This will delete ALL delegate sessions and logs!${NC}"
        echo -n "Are you sure? (y/N): "
        read -r confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo -e "${YELLOW}Cancelled${NC}"
            return 0
        fi

        # Kill all sessions
        local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep "^delegate-" || true)
        for session in $sessions; do
            tmux kill-session -t "$session" 2>/dev/null
            echo -e "${RED}Killed:${NC} $session"
        done

        # Delete all logs
        local log_count=$(ls ${LOG_DIR}/*.log ${LOG_DIR}/*.txt 2>/dev/null | wc -l)
        rm -f ${LOG_DIR}/*.log ${LOG_DIR}/*.txt 2>/dev/null
        echo -e "${RED}Deleted:${NC} $log_count log files"
    else
        # Purge specific session
        local session="delegate-$name"

        # Kill tmux sessions
        tmux kill-session -t "$session" 2>/dev/null && echo -e "${RED}Killed:${NC} $session"
        tmux kill-session -t "${session}-continue" 2>/dev/null && echo -e "${RED}Killed:${NC} ${session}-continue"

        # Delete logs for this session
        local log_files=$(ls ${LOG_DIR}/*_${name}_*.log ${LOG_DIR}/*_${name}_*.txt 2>/dev/null || true)
        if [[ -n "$log_files" ]]; then
            local count=$(echo "$log_files" | wc -l)
            rm -f ${LOG_DIR}/*_${name}_*.log ${LOG_DIR}/*_${name}_*.txt 2>/dev/null
            echo -e "${RED}Deleted:${NC} $count log files for '$name'"
        else
            echo -e "${YELLOW}No logs found for:${NC} $name"
        fi
    fi
}

check_session() {
    local name="$1"
    local session="delegate-$name"

    if tmux has-session -t "$session" 2>/dev/null; then
        # Check if actively running or just idle (waiting on 'read')
        local pane_pid=$(tmux list-panes -t "$session" -F '#{pane_pid}' 2>/dev/null)
        local children=$(ps --ppid "$pane_pid" -o comm= 2>/dev/null | grep -v '^$' | wc -l)

        if [[ "$children" -gt 0 ]]; then
            echo -e "${YELLOW}⏳ Running${NC}  $name"
        else
            echo -e "${BLUE}💤 Idle${NC}     $name (task complete, session open)"
        fi
    else
        # Check if there are log files for this session (it ran but completed)
        local log_files=$(ls -t ${LOG_DIR}/*_${name}_*.log 2>/dev/null | head -1)
        if [[ -n "$log_files" ]]; then
            echo -e "${GREEN}✅ Done${NC}     $name"
        else
            echo -e "${RED}❓ Unknown${NC}  $name (no session or logs found)"
            return 1
        fi
    fi
    return 0
}

check_all_sessions() {
    echo -e "${GREEN}Delegate Session Status${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"

    # Get all unique task names from logs and active sessions
    local all_names=""

    # From active tmux sessions
    local active=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep "^delegate-" | sed 's/^delegate-//' || true)

    # From log files (extract task name from filename pattern: YYYYMMDD_HHMMSS_name_stdout.log)
    # The timestamp is 15 chars: YYYYMMDD_HHMMSS
    local from_logs=$(ls ${LOG_DIR}/*_stdout.log 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/^[0-9]\{8\}_[0-9]\{6\}_//' | sed 's/_stdout\.log$//' | sort -u || true)

    # Combine and deduplicate
    all_names=$(echo -e "$active\n$from_logs" | grep -v '^$' | sort -u)

    if [[ -z "$all_names" ]]; then
        echo -e "${YELLOW}No delegate sessions found${NC}"
        return 0
    fi

    local running=0
    local idle=0
    local done=0

    for name in $all_names; do
        local session="delegate-$name"
        if tmux has-session -t "$session" 2>/dev/null; then
            # Check if actively running or just idle (waiting on 'read')
            local pane_pid=$(tmux list-panes -t "$session" -F '#{pane_pid}' 2>/dev/null)
            local children=$(ps --ppid "$pane_pid" -o comm= 2>/dev/null | grep -v '^$' | wc -l)

            if [[ "$children" -gt 0 ]]; then
                echo -e "${YELLOW}⏳ Running${NC}  $name"
                running=$((running + 1))
            else
                echo -e "${BLUE}💤 Idle${NC}     $name"
                idle=$((idle + 1))
            fi
        else
            echo -e "${GREEN}✅ Done${NC}     $name"
            done=$((done + 1))
        fi
    done

    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    echo -e "Total: ${YELLOW}$running running${NC}, ${BLUE}$idle idle${NC}, ${GREEN}$done completed${NC}"
}

continue_session() {
    local name="$1"
    local message="$2"
    local session="delegate-$name"

    if [[ -z "$message" ]]; then
        echo -e "${RED}Error: No message provided for --continue${NC}"
        echo -e "Usage: delegate.sh --continue <name> \"<message>\""
        exit 1
    fi

    # Find the most recent stderr log for this session to get the session ID
    local stderr_log=$(ls -t ${LOG_DIR}/*_${name}_stderr.log 2>/dev/null | head -1)

    if [[ -z "$stderr_log" ]]; then
        echo -e "${RED}Error: No logs found for session '$name'${NC}"
        echo -e "Cannot continue a session that was never started."
        exit 1
    fi

    # Extract the codex session ID from the log
    # Codex outputs something like "session id: abc123" or stores it in the log
    local session_id=$(grep -oP 'session id:\s*\K[a-zA-Z0-9_-]+' "$stderr_log" | tail -1)

    if [[ -z "$session_id" ]]; then
        # Try alternative pattern - codex might output it differently
        session_id=$(grep -oP 'Session:\s*\K[a-zA-Z0-9_-]+' "$stderr_log" | tail -1)
    fi

    if [[ -z "$session_id" ]]; then
        # Try to find any session-like ID in the log
        session_id=$(grep -oP 'ses_[a-zA-Z0-9]+' "$stderr_log" | tail -1)
    fi

    if [[ -z "$session_id" ]]; then
        echo -e "${RED}Error: Could not find codex session ID in logs${NC}"
        echo -e "Log file: $stderr_log"
        echo -e ""
        echo -e "The session may have completed without storing a session ID,"
        echo -e "or codex may not have output the session ID in a recognizable format."
        echo -e ""
        echo -e "You can try:"
        echo -e "  1. Start a new task: delegate.sh -c <role> -g \"<goal>\" -t \"<task>\" -n new-name"
        echo -e "  2. Check the log manually: tail $stderr_log"
        exit 1
    fi

    # Get log file base from original session - use timestamp for unique continue logs
    local log_base=$(echo "$stderr_log" | sed 's/_stderr\.log$//')
    local continue_timestamp=$(date +"%Y%m%d_%H%M%S")
    local continue_stderr="${log_base}_continue_${continue_timestamp}_stderr.log"
    local continue_stdout="${log_base}_continue_${continue_timestamp}_stdout.log"

    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Continuing session: $name${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Session ID:${NC} $session_id"
    echo -e "${YELLOW}Message:${NC} $message"
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"

    # Function to check if a tmux session is busy (has child processes running)
    is_session_busy() {
        local check_session="$1"

        # If tmux session doesn't exist, not busy
        if ! tmux has-session -t "$check_session" 2>/dev/null; then
            return 1
        fi

        # Get the pane's shell PID
        local pane_pid=$(tmux list-panes -t "$check_session" -F '#{pane_pid}' 2>/dev/null)

        if [[ -z "$pane_pid" ]]; then
            return 1
        fi

        # Check if there are any child processes (codex, tee, etc.)
        # If no children, the shell is idle (waiting on 'read')
        local children=$(ps --ppid "$pane_pid" -o comm= 2>/dev/null | grep -v '^$' | wc -l)

        if [[ "$children" -gt 0 ]]; then
            return 0  # Busy - has child processes
        else
            return 1  # Not busy - shell is idle
        fi
    }

    # Wait for any active codex processes to complete (exponential backoff)
    local wait_time=1
    local max_wait=60
    local total_waited=0

    while is_session_busy "$session" || is_session_busy "${session}-continue"; do
        echo -e "${YELLOW}⏳ Previous task still running, waiting ${wait_time}s...${NC}"
        sleep "$wait_time"
        total_waited=$((total_waited + wait_time))

        # Exponential backoff: 1, 2, 4, 8, 16, 32, 60, 60, ...
        wait_time=$((wait_time * 2))
        if [[ $wait_time -gt $max_wait ]]; then
            wait_time=$max_wait
        fi

        # Safety timeout after 10 minutes
        if [[ $total_waited -gt 600 ]]; then
            echo -e "${RED}Timeout: Previous task still running after 10 minutes${NC}"
            echo -e "You can:"
            echo -e "  - Kill it: delegate.sh --kill $name"
            echo -e "  - Attach:  tmux attach -t $session"
            exit 1
        fi
    done

    if [[ $total_waited -gt 0 ]]; then
        echo -e "${GREEN}✓ Previous task completed after ${total_waited}s${NC}"
    fi

    # Clean up old tmux sessions (they're just waiting on 'read' now)
    tmux kill-session -t "$session" 2>/dev/null || true
    tmux kill-session -t "${session}-continue" 2>/dev/null || true

    # Create a fresh tmux session for this continuation
    local new_session="${session}-continue"
    TMUX_CMD="echo '$message' | codex exec --yolo resume '$session_id' - 2> >(tee -a '$continue_stderr' >&2) | tee -a '$continue_stdout'; echo ''; echo 'Continuation completed. Press Enter to close or Ctrl+C to keep open.'; read"
    tmux new-session -d -s "$new_session" "bash -c \"$TMUX_CMD\""

    echo -e "${GREEN}✓ Continuation started${NC}"
    echo -e ""
    echo -e "${YELLOW}Session:${NC} $new_session"
    echo -e "${YELLOW}Logs:${NC}"
    echo -e "  stdout: $continue_stdout"
    echo -e "  stderr: $continue_stderr"
    echo -e ""
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  Attach:  tmux attach -t $new_session"
    echo -e "  Tail:    tail -f $continue_stderr"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}
