{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Finnish keyboard layout configuration
  console.keyMap = "fi";
  
  # X11 keyboard layout (used by some applications even in Wayland)
  services.xserver.xkb = {
    layout = "fi";
    variant = "";
    options = "caps:escape"; # Optional: Makes Caps Lock work as Escape
  };
}
