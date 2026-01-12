# Role helpers for delegate.sh

list_roles() {
    echo -e "${GREEN}Available common roles:${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
    if [[ -d "$COMMON_ROLES_DIR" ]]; then
        for role_file in "$COMMON_ROLES_DIR"/*.md; do
            if [[ -f "$role_file" ]]; then
                local role_name=$(basename "$role_file" .md)
                local first_line=$(head -1 "$role_file" | sed 's/^# //')
                echo -e "  ${YELLOW}$role_name${NC}"
                echo -e "    $first_line"
                echo ""
            fi
        done
    else
        echo -e "${RED}No common-roles directory found at: $COMMON_ROLES_DIR${NC}"
    fi
}

load_common_role() {
    local role_name="$1"
    local role_file="$COMMON_ROLES_DIR/${role_name}.md"

    if [[ ! -f "$role_file" ]]; then
        echo -e "${RED}Error: Common role not found: $role_name${NC}" >&2
        echo -e "Looking for: $role_file" >&2
        echo -e "Available roles:" >&2
        ls "$COMMON_ROLES_DIR"/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/\.md$//' >&2
        exit 1
    fi

    # Read the role file, skip the first line if it's a markdown header
    local content=$(cat "$role_file")
    if [[ "$content" == "#"* ]]; then
        # Skip the first line (title) and any empty lines after it
        content=$(echo "$content" | tail -n +2 | sed '/^$/d' | head -1)
        # If the second line is empty, get the actual content
        if [[ -z "$content" ]]; then
            content=$(cat "$role_file" | tail -n +2 | grep -v '^$' | head -1)
        fi
        # Actually, let's get everything after the title
        content=$(cat "$role_file" | tail -n +3)
    fi

    echo "$content"
}
