#!/usr/bin/env bash
#
# Component runner of scripts/bootstrap.sh. Only bootstrap.sh uses this file.
# The components use scripts/tools/logging.sh.
#
# While a component runs, a spinner and the last lines of its output appear.
# When the component finishes, they collapse into one line. The full output
# goes to a log file.
#
# Before the source of this file, set these variables:
#   DOTFILES_ROOT  absolute path of the repository
#   VERBOSE        1 shows the full output of every component
#   SKIP_SUDO      1 does not ask for the password
#
# This file must work with bash 3.2, the bash of a new Mac.

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

LOG_DIR="${TMPDIR:-/tmp}"
LOG_DIR="${LOG_DIR%/}/dotfiles-logs"
TAIL_LINES=10
FAIL_LOG_LINES=20

SPINNER_FRAMES=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
COUNT_OK=0
COUNT_SKIP=0
FAILED_NAMES=()
FAILED_SCRIPTS=()
SUDO_PID=''
START_ALL=0

# The live view redraws lines in place, so it needs a terminal.
if [ -t 1 ] && [ "$VERBOSE" != '1' ]
then
    LIVE=1
else
    LIVE=0
fi

###############################################################################
# Helpers                                                                     #
###############################################################################

function fmt_duration() {
    local total=$1

    if [ "$total" -lt 60 ]
    then
        printf '%ds' "$total"
    else
        printf '%dm %02ds' "$((total / 60))" "$((total % 60))"
    fi
}

function print_header() {
    local count=$1

    printf '\n  %sdotfiles%s  %s·  %d components  ·  %s%s\n\n' \
        "$c_bold" "$c_reset" "$c_dim" "$count" "$(date '+%Y-%m-%d %H:%M')" "$c_reset"
}

function print_summary() {
    local total=$1 aborted=$2

    printf '\n  %d ok  ·  %d skipped  ·  %d failed  ·  %s\n' \
        "$COUNT_OK" "$COUNT_SKIP" "${#FAILED_NAMES[@]}" "$(fmt_duration "$total")"

    if [ -n "$aborted" ]
    then
        printf '  %sThe installation stopped after %s. Use KEEP_GOING=1 to continue.%s\n' \
            "$c_yellow" "$aborted" "$c_reset"
    fi

    printf '\n'
}

function print_failures() {
    local i=0 log

    while [ "$i" -lt "${#FAILED_NAMES[@]}" ]
    do
        log="$LOG_DIR/${FAILED_NAMES[$i]}.log"
        printf '  %s✗ %s%s\n' "$c_red" "${FAILED_NAMES[$i]}" "$c_reset"
        tail -n "$FAIL_LOG_LINES" "$log" | sed 's/^/      /'
        printf '      %sfull log : %s%s\n' "$c_dim" "$log" "$c_reset"
        printf '      %sretry    : DOTFILES_ROOT=%s %s%s\n\n' "$c_dim" "$DOTFILES_ROOT" "$DOTFILES_ROOT/${FAILED_SCRIPTS[$i]}" "$c_reset"
        i=$((i + 1))
    done
}

# Ask for the password once, before the first component.
#
# Homebrew uses sudo to upgrade some casks, for example docker-desktop and
# spotify. A component runs in the background, where a sudo prompt cannot
# read the terminal. A loop refreshes the sudo timestamp every 50 seconds, so
# sudo does not ask again during the installation.
function start_sudo_keepalive() {
    if [ "$SKIP_SUDO" = '1' ]
    then
        return 0
    fi

    if ! sudo -v -p "  ${c_yellow}??${c_reset}  Password of your account (brew upgrades some casks with sudo): "
    then
        warn 'sudo has no password. Some casks can fail'
        return 0
    fi

    printf '\n'

    while kill -0 "$$" 2> /dev/null
    do
        sudo -n true 2> /dev/null
        sleep 50
    done &
    SUDO_PID=$!
}

function stop_sudo_keepalive() {
    if [ -n "$SUDO_PID" ]
    then
        kill "$SUDO_PID" 2> /dev/null
        SUDO_PID=''
    fi
}

###############################################################################
# Component runner                                                            #
###############################################################################

# Draw the spinner and the last lines of the log until the component ends.
#
# The cursor stays at the end of the last line of the block. Each frame moves
# the cursor up to the first line, clears the screen below it and draws the
# block again. At the end the block disappears, and the caller writes the
# result on that line.
function show_progress() {
    local pid=$1 prefix=$2 log=$3 start=$4
    local frame=0 drawn=0 width line

    width=$(( $(tput cols 2> /dev/null || echo 80) - 8 ))

    while kill -0 "$pid" 2> /dev/null
    do
        if [ "$drawn" -gt 0 ]
        then
            printf '\033[%dA' "$drawn"
        fi

        printf '\r\033[J%s %s%s%s  %s' "$prefix" \
            "$c_blue" "${SPINNER_FRAMES[$frame]}" "$c_reset" "$(fmt_duration "$((SECONDS - start))")"

        # sed removes colour codes, and keeps only the text after the last
        # carriage return of a progress bar. cut keeps each line on one row.
        drawn=0
        while IFS= read -r line || [ -n "$line" ]
        do
            printf '\n      %s│ %s%s' "$c_dim" "$line" "$c_reset"
            drawn=$((drawn + 1))
        done < <(tail -n "$TAIL_LINES" "$log" \
            | sed -e $'s/\033\\[[0-9;?]*[A-Za-z]//g' -e $'s/.*\r//' \
            | cut -c "1-$width")

        frame=$(( (frame + 1) % ${#SPINNER_FRAMES[@]} ))
        sleep 0.2
    done

    if [ "$drawn" -gt 0 ]
    then
        printf '\033[%dA' "$drawn"
    fi

    printf '\r\033[J'
}

# Run one component. The return code is 1 when the component fails, and 0
# when it succeeds or when it is skipped.
function run_component() {
    local index=$1 total=$2 name=$3 script=$4 requires=$5
    local log="$LOG_DIR/$name.log"
    local start=$SECONDS
    local prefix bin missing='' pid status

    prefix=$(printf '  [%2d/%2d] %-10s' "$index" "$total" "$name")

    # `requires` comes from the registry: comma separated, or `-` for none.
    if [ "$requires" = '-' ]
    then
        requires=''
    fi

    for bin in ${requires//,/ }
    do
        if ! command -v "$bin" > /dev/null 2>&1
        then
            missing="$missing $bin"
        fi
    done

    if [ -n "$missing" ]
    then
        printf '%s %s·%s  %sskipped, missing:%s%s\n' \
            "$prefix" "$c_yellow" "$c_reset" "$c_dim" "$missing" "$c_reset"
        COUNT_SKIP=$((COUNT_SKIP + 1))
        return 0
    fi

    if [ "$LIVE" = '1' ]
    then
        "$DOTFILES_ROOT/$script" < /dev/null > "$log" 2>&1 &
        pid=$!
        show_progress "$pid" "$prefix" "$log" "$start"
        wait "$pid"
        status=$?
    else
        printf '%s\n' "$prefix"
        "$DOTFILES_ROOT/$script" < /dev/null 2>&1 | tee "$log"
        status=${PIPESTATUS[0]}
    fi

    if [ "$status" -eq 0 ]
    then
        printf '%s %s✓%s  %s\n' "$prefix" "$c_green" "$c_reset" "$(fmt_duration "$((SECONDS - start))")"
        COUNT_OK=$((COUNT_OK + 1))
        return 0
    fi

    printf '%s %s✗%s  %s  %sexit %d%s\n' "$prefix" "$c_red" "$c_reset" \
        "$(fmt_duration "$((SECONDS - start))")" "$c_dim" "$status" "$c_reset"
    FAILED_NAMES+=("$name")
    FAILED_SCRIPTS+=("$script")

    return 1
}

###############################################################################
# Run lifecycle                                                               #
###############################################################################

# Prepare the log directory, show the header and ask for the password.
function start_run() {
    local count=$1

    rm -rf "$LOG_DIR"
    mkdir -p "$LOG_DIR"

    print_header "$count"
    start_sudo_keepalive
    START_ALL=$SECONDS
}

# Show the summary and the failures. The return code is 1 when a component
# failed, and 0 otherwise.
function finish_run() {
    local aborted=$1

    print_summary "$((SECONDS - START_ALL))" "$aborted"

    if [ "${#FAILED_NAMES[@]}" -gt 0 ]
    then
        print_failures
        return 1
    fi

    return 0
}
