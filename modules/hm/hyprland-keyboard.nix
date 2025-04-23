{
  config,
  lib,
  pkgs,
  ...
}:

{
  hydenix.hm.hyprland = {
    # Add direct config options to the Hyprland config
    extraConfig = ''
      # Set keyboard layout explicitly
      input {
          kb_layout = fi
          kb_variant =
          kb_model =
          kb_options = caps:escape
          kb_rules =
          follow_mouse = 1
          touchpad {
              natural_scroll = false
          }
          sensitivity = 0
      }
    '';
  };
};
