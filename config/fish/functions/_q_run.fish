function _q_run --description "run llm with base args; split llm flags from unquoted prompt words"
    set -l base
    while test "$argv[1]" != "--"
        set base $base $argv[1]
        set -e argv[1]
    end
    set -e argv[1]
    set -l flags
    set -l words
    set -l i 1
    while test $i -le (count $argv)
        set -l a $argv[$i]
        switch $a
            case -o --option
                set flags $flags $argv[$i..(math $i + 2)]
                set i (math $i + 3)
            case -m --model -s --system -t --template -a --attachment -f --fragment -k --key -n --no-log-dummy
                set flags $flags $argv[$i..(math $i + 1)]
                set i (math $i + 2)
            case '-*'
                set flags $flags $a
                set i (math $i + 1)
            case '*'
                set words $words $a
                set i (math $i + 1)
        end
    end
    llm $base $flags (string join " " -- $words)
end
