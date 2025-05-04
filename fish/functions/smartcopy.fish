function smartcopy
    set -l target $argv[1]

    if test -z "$target"
        echo "Usage: smartcopy <file|command>"
        return 1
    end

    if test -e "$target"
        # Get MIME type
        set -l mimetype (file --mime-type -b -- "$target")

        switch $mimetype
            case 'text/*'
                cat -- "$target" | wl-copy
                echo "✅ Copied text content of '$target' to clipboard."
            case '*'
                cat -- "$target" | wl-copy -t "$mimetype"
                echo "✅ Copied file '$target' with MIME type '$mimetype'."
        end
    else
        # Evaluate as command and copy output
        set -l output (eval $target ^/dev/null)

        if test -z "$output"
            echo "❌ Command '$target' failed or returned no output."
            return 1
        end

        echo "$output" | wl-copy
        echo "✅ Copied output of command '$target' to clipboard."
    end
end
