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
    # Create the local config file
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

    # Create a user-editable userprefs.conf
    home.activation.setupHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      USERPREFS="$HOME/.config/hypr/userprefs.conf"
      LOCAL_CONF="$HOME/.config/hypr/local.conf"
      MARKER="# --- LOCAL USER CONFIG --- "
      ORIGINAL_PATH="${pkgs.hydenix.hyde}/Configs/.config/hypr/userprefs.conf"
      
      # Ensure the directory exists
      mkdir -p "$(dirname "$USERPREFS")"
      
      # Check if the file is a symlink
      if [ -L "$USERPREFS" ]; then
        echo "Removing symlink to Nix store"
        rm "$USERPREFS"
      fi
      
      # Create the userprefs file if it doesn't exist or was a symlink
      if [ ! -f "$USERPREFS" ]; then
        echo "Creating new userprefs.conf from original"
        cp "$ORIGINAL_PATH" "$USERPREFS" 2>/dev/null || touch "$USERPREFS"
      fi
      
      # Ensure the file is writable
      chmod 644 "$USERPREFS"
      
      # Check if our configuration is already in the file
      if ! grep -q "$MARKER" "$USERPREFS"; then
        echo "Adding local configuration to userprefs.conf"
        echo "" >> "$USERPREFS"
        echo "$MARKER" >> "$USERPREFS"
        cat "$LOCAL_CONF" >> "$USERPREFS"
      else
        echo "Local configuration already present in userprefs.conf"
      fi
    '';
  };
}
