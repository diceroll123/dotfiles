# Run pyright, ty, and basedpyright on a Python file via uvx (no local install).
#
# Run from the project root (cwd). Usage: typecheck <path-to-file.py>  (alias: ,tc)

typecheck() {
    emulate -L zsh -o pipefail -o nounset

    if [[ $# -lt 1 || -z "$1" ]]; then
        echo "usage: typecheck <path-to-file.py>  (cwd: project root)" >&2
        return 2
    fi

    local root="${PWD:A}"
    local target="$1"

    if [[ ! -f "$target" ]]; then
        echo "error: file not found: $target" >&2
        return 2
    fi

    local status=0
    run() {
        local name=$1
        shift
        print ""
        print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        print " $name"
        print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        if ! "$@"; then
            status=1
        fi
    }

    run "uvx pyright" uvx pyright "$target"
    run "uvx basedpyright" uvx basedpyright "$target"
    run "uvx ty check" uvx ty check --project "$root" "$target"

    return "$status"
}

alias ,tc=typecheck

