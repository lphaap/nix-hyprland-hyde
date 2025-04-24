{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hydenix.hm.hyprland;
in {
home.file = {
  ".config/hypr/userprefs.conf" = {
    source = "${pkgs.hydenix.hyde}/Configs/.config/hypr/userprefs.conf";
    force = true;
    mutable = true;
  };
  
  # Then also create our own override file
  ".config/hypr/local.conf" = { 
    text = ''
      # Finnish keyboard layout configuration
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
  };
};

# And still use the activation script to merge them
home.activation.mergeHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
  # Now the file should already be copied and mutable
  USERPREFS="$HOME/.config/hypr/userprefs.conf"
  KEYBOARD_CONF="$HOME/.config/hypr/local.conf"
  MARKER="# --- LOCAL USER CONFIG --- "
  
  if [ -f "$USERPREFS" ] && [ -f "$KEYBOARD_CONF" ]; then
    if ! grep -q "$MARKER" "$USERPREFS"; then
      echo "" >> "$USERPREFS"
      echo "$MARKER" >> "$USERPREFS"
      cat "$KEYBOARD_CONF" >> "$USERPREFS"
      echo "Local configuration added to userprefs.conf"
    fi
  fi
'';
}
