{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Hyprland-specific keyboard configuration
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        kb_layout = "fi";
        kb_options = "caps:escape";
      };
    };
  };
}
