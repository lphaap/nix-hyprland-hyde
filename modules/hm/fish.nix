{
  config,
  lib,
  pkgs,
  ...
}:
{
home.sessionVariables = {
  CC = "${pkgs.gcc}/bin/gcc";
  CXX = "${pkgs.gcc}/bin/g++";
};

home.file.".config/fish/hyde_config.fish".text = ''
  # Set Fish greeting to empty (no welcome message)
  set fish_greeting

  # Add ~/.local/bin to PATH if it exists
  if test -d $HOME/.local/bin
    if not contains $HOME/.local/bin $PATH
      set -p PATH $HOME/.local/bin
    end
  end

  # Initialize Starship prompt if available
  if type -q starship
    starship init fish | source
  end

  # Initialize zoxide (smart cd) if available
  if type -q zoxide
    zoxide init fish | source
  end

  # Initialize direnv if available
  if type -q direnv
    direnv hook fish | source
  end

  # Initialize any-nix-shell if available (for better nix-shell support)
  if type -q any-nix-shell
    any-nix-shell fish --info-right | source
  end

  # Ensure we have color support
  set -g fish_term24bit 1

  # Use eza instead of ls if available
  if type -q eza
    alias ls="eza --icons=auto"
    alias l="eza -lh --icons=auto"
    alias ll="eza -lha --icons=auto --sort=name --group-directories-first"
    alias lt="eza --tree --icons=auto"
    alias lta="eza --tree --icons=auto -a"
  else
    # Fallback to standard ls with colors
    alias l="ls -lh"
    alias ll="ls -lha"
  end

  # Common aliases
  alias c="clear"
  alias ..="cd .."
  alias ...="cd ../.."
  alias .3="cd ../../.."
  alias .4="cd ../../../.."
  alias md="mkdir -p"
  alias rd="rmdir"
  alias mkdir="mkdir -p"

  # Git aliases
  alias g="git"
  alias gs="git status"
  alias ga="git add"
  alias gc="git commit"
  alias gp="git push"
  alias gl="git log --oneline --graph"

  # Nix aliases
  alias nb="sudo nixos-rebuild"
  alias nbs="sudo nixos-rebuild switch"
  alias nbt="sudo nixos-rebuild test"
  alias nbb="sudo nixos-rebuild boot"
  alias nd="nix develop"
  alias nr="nix run"
  alias ns="nix shell"

  # Editor aliases
  alias v="$EDITOR"
  alias vi="$EDITOR"

  # Safety features
  alias cp="cp -i"
  alias mv="mv -i"
  alias rm="rm -i"

  # Colorful commands if available
  alias grep="grep --color=auto"
  alias diff="diff --color=auto"
  alias ip="ip -color=auto"

  # Useful functions
  function take
    mkdir -p $argv[1]
    cd $argv[1]
  end

  # Set default editor based on availability
  if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
  else if type -q vim
    set -gx EDITOR vim
    set -gx VISUAL vim
  else
    set -gx EDITOR nano
    set -gx VISUAL nano
  end

  # Add pokego (ASCII art) if available and in an interactive terminal
  if type -q pokego; and status is-interactive
    pokego --no-title -r 1,3,6
  end

  # Fish color scheme - Old School
  set -U fish_color_normal normal
  set -U fish_color_command 00FF00
  set -U fish_color_keyword 00FF00
  set -U fish_color_quote ff8787
  set -U fish_color_redirection 7BFF7B
  set -U fish_color_end ff8787
  set -U fish_color_error A40000
  set -U fish_color_param 00ff00
  set -U fish_color_comment ff8787
  set -U fish_color_match --background=brblue
  set -U fish_color_selection white --bold --background=brblack
  set -U fish_color_search_match bryellow --background=brblack
  set -U fish_color_history_current --bold
  set -U fish_color_operator 00a6b2
  set -U fish_color_escape 00a6b2
  set -U fish_color_cwd green
  set -U fish_color_cwd_root red
  set -U fish_color_option 30BE30
  set -U fish_color_valid_path --underline
  set -U fish_color_autosuggestion 777777
  set -U fish_color_user brgreen
  set -U fish_color_host normal
  set -U fish_color_host_remote yellow
  set -U fish_color_status red
  set -U fish_color_cancel --reverse
  set -U fish_pager_color_prefix normal --bold --underline
  set -U fish_pager_color_progress brwhite --background=cyan
  set -U fish_pager_color_completion normal
  set -U fish_pager_color_description B3A06D
  set -U fish_pager_color_selected_background --background=brblack

  # Load local config if it exists
  if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
  end
'';

# In modules/hm/shell.nix

home.packages = with pkgs; [
    starship        # For prompt
    zoxide          # Smart cd command
    direnv          # Directory environment manager
    any-nix-shell   # Better nix-shell support
    eza             # Modern ls replacement
    fd              # Modern find replacement
    bat             # Better cat with syntax highlighting
    fzf             # Fuzzy finder
];

}

