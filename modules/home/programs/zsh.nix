{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "tmux"
        "asdf"
      ];
    };
    sessionVariables = {
      BUN_INSTALL = "$HOME/.bun";
      JAVA_HOME = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home";
      ZSH = "$HOME/.oh-my-zsh";
    };
    initContent = ''
      # OpenSpec shell completions
      fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
      autoload -Uz compinit
      compinit

      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
      export PATH="$BUN_INSTALL/bin:$PATH"
      export PATH="$PATH:$HOME/.lmstudio/bin"

      [ -s "$HOME/.asdf/plugins/golang/set-env.zsh" ] && . "$HOME/.asdf/plugins/golang/set-env.zsh"
      [ -s "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      [ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
      [ -s "$HOME/.aftman/env" ] && . "$HOME/.aftman/env"

      if command -v brew >/dev/null 2>&1; then
        eval "$(brew shellenv)"
      fi

      workbits-monitoring() {
        local sock=/tmp/workbits-monitoring.sock
        if ssh -S "$sock" -O check workbits-vps >/dev/null 2>&1; then
          echo "Workbits monitoring tunnel already running"
          return 0
        fi

        rm -f "$sock"
        ssh -M -S "$sock" -fN -o ExitOnForwardFailure=yes workbits-vps \
          -L 127.0.0.1:18081:127.0.0.1:3001 \
          -L 127.0.0.1:18082:127.0.0.1:3002 \
          -L 127.0.0.1:18090:127.0.0.1:9090
        echo "Workbits monitoring tunnel started"
      }

      workbits-monitoring-stop() {
        local sock=/tmp/workbits-monitoring.sock
        ssh -S "$sock" -O exit workbits-vps >/dev/null 2>&1 && echo "Workbits monitoring tunnel stopped" || echo "Workbits monitoring tunnel was not running"
        rm -f "$sock"
      }

      alias workbits-grafana='open http://grafana.workbits.local'
      alias workbits-status='open http://status.workbits.local'
      alias workbits-prometheus='open http://prometheus.workbits.local'
    '';
  };
}
