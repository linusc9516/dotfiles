switch (uname)
    case Darwin
        # ── macOS ──

        # Homebrew (arm64 default)
        fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

        # User local bins
        fish_add_path ~/.local/bin

        # Spicetify (macOS specific)
        fish_add_path ~/.spicetify

        # pipx (macOS)
        fish_add_path ~/.local/bin

        # macOS alert function (uses native notification)
        function alert
            if test $status -eq 0
                set result "Success"
            else
                set result "Failure"
            end
            set last_cmd (history --max=1 | sed -E 's/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//')
            osascript -e "display notification \"$last_cmd\" with title \"$result\""
        end

        # macOS GPU/CPU (optional)
        alias mem 'vm_stat | head -10'

    case Linux
        # ── Linux / WSL2 ──

        # Default paths
        fish_add_path ~/.local/bin

        # CUDA (if present)
        if test -d /usr/local/cuda/lib64
            set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
        end

        # WSL-specific exports
        if grep -qi microsoft /proc/version 2>/dev/null
            set -gx BROWSER "/mnt/c/Users/slmlaggi/AppData/Local/Thorium/Application/thorium.exe"
            set -gx ANDROID_HOME "/mnt/c/Users/slmlaggi/AppData/Local/Android/Sdk"
            set -gx WSLENV ANDROID_HOME/p
        else
            # Native Linux browser fallback
            set -gx BROWSER "firefox"
        end

        # Java (Ubuntu default path)
        set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

        # Linux alert function (notify-send)
        function alert
            if test $status -eq 0
                set icon terminal
            else
                set icon error
            end
            set last_cmd (history --max=1 | sed -E 's/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//')
            notify-send --urgency=low -i $icon $last_cmd
        end

        # Memory / CPU shortcuts
        alias mem 'free -m -l -t'
        alias cpu 'lscpu'

        # Android Studio (if installed)
        alias android '/opt/android-studio/bin/studio'

        # Flask dev server (your local setup)
        alias frun 'flask --app app.py --debug run'

        # Jupyter (user-local)
        alias jupyter-notebook '~/.local/bin/jupyter-notebook --no-browser'
end