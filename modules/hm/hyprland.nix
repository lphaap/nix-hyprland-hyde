{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hydenix.hm.hyprland;
in {
  config = lib.mkIf cfg.enable {
    # Create a keyboard config that we'll append to userprefs.conf
    home.file.".config/hypr/local.conf" = { 
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

    # Add an activation script that makes the userprefs file modifiable and adds our config
    home.activation.loadLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      USERPREFS="$HOME/.config/hypr/userprefs.conf"
      KEYBOARD_CONF="$HOME/.config/hypr/local.conf"
      MARKER="# --- LOCAL USER CONFIG --- "
      
      # Make sure userprefs.conf exists and is modifiable
      if [ -f "$USERPREFS" ]; then
        # Make the file writable
        chmod u+w "$USERPREFS" || true
        
        # Check if our configuration is already in the file
        if ! grep -q "$MARKER" "$USERPREFS"; then
          echo "Adding local configuration to userprefs.conf"
          cat "$KEYBOARD_CONF" >> "$USERPREFS" || true
        else
          echo "Local configuration already present in userprefs.conf"
        fi
      else
        echo "Warning: userprefs.conf not found, creating it with keyboard config"
        mkdir -p "$(dirname "$USERPREFS")"
        cat "$KEYBOARD_CONF" > "$USERPREFS" || true
      fi
      
      # Always exit successfully
      exit 0
    '';
    
  };
}
