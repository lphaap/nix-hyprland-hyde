{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Create a custom keyboard config file
  home.file.".config/hypr/hyprland.conf.d/keyboard.conf".text = ''
    input {
        kb_layout = fi
        kb_variant =
        kb_model =
        kb_options = caps:escape
        kb_rules =
        follow_mouse = 1
        sensitivity = 0
    }
  '';
}
