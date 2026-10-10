function dsh --wraps dsh --description 'dsh; "dsh web" never opens the browser'
    if test "$argv[1]" = web; and not contains -- --no-open $argv
        command dsh web --no-open $argv[2..-1]
    else
        command dsh $argv
    end
end
