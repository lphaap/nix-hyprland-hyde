{
  config,
  lib,
  pkgs,
  ...
}:

{
home.file.".config/fish/config.fish".text = ''

  # Set Fish greeting to empty
  set fish_greeting

  # Initialize Starship prompt if available
  if command -v starship > /dev/null
    starship init fish | source
  end

  # Add your aliases
  alias l="ls -la"
  alias c="clear"
  alias ..="cd .."


  # Add any custom functions or settings you need
'';
}
