{
  config,
  lib,
  pkgs,
  ...
}:

{
home.file.".config/fish/config.fish".text = ''
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

  # Fish color scheme - based on Catppuccin Mocha
  set -U fish_color_normal cdd6f4
  set -U fish_color_command 89b4fa
  set -U fish_color_param f2cdcd
  set -U fish_color_quote a6e3a1
  set -U fish_color_redirection f5c2e7
  set -U fish_color_end fab387
  set -U fish_color_error f38ba8
  set -U fish_color_selection --background=313244
  set -U fish_color_search_match --background=313244
  set -U fish_color_operator f5c2e7
  set -U fish_color_escape eba0ac
  set -U fish_color_autosuggestion 6c7086
  set -U fish_color_comment 7f849c
  set -U fish_color_valid_path --underline
  set -U fish_pager_color_prefix f5c2e7
  set -U fish_pager_color_completion 89dceb
  set -U fish_pager_color_description 7f849c
  set -U fish_pager_color_progress 89b4fa
  set -U fish_pager_color_selected_background --background=313244

  # Load local config if it exists
  if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
  end
''
}
