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
    # Declare userprefs.conf as a mutable file
    home.file.".config/hypr/userprefs.conf" = {
      source = "${pkgs.hydenix.hyde}/Configs/.config/hypr/userprefs.conf";
      force = true;
      mutable = true;
    };
    
    # Create a local config file with custom settings
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

    # Add an activation script that integrates our local config
    # Note: We use mutableGeneration to ensure it runs after the mutable files are set up
    home.activation.mergeLocalConfig = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
      USERPREFS="$HOME/.config/hypr/userprefs.conf"
      LOCAL_CONF="$HOME/.config/hypr/local.conf"
      MARKER="# --- LOCAL USER CONFIG --- "
      
      # Ensure the directory exists (though it should already by now)
      mkdir -p "$(dirname "$USERPREFS")"
      
      if [ -f "$USERPREFS" ]; then
        # Check if our configuration is already in the file
        if ! grep -q "$MARKER" "$USERPREFS"; then
          echo "Adding local configuration to userprefs.conf"
          echo "" >> "$USERPREFS"
          echo "$MARKER" >> "$USERPREFS"
          cat "$LOCAL_CONF" >> "$USERPREFS"
        else
          echo "Local configuration already present in userprefs.conf"
          # Optionally update existing configuration if needed
          # sed -i "/$MARKER/,$ d" "$USERPREFS"
          # echo "$MARKER" >> "$USERPREFS"
          # cat "$LOCAL_CONF" >> "$USERPREFS"
        fi
      else
        echo "Warning: userprefs.conf not found, creating it with local config"
        echo "$MARKER" > "$USERPREFS"
        cat "$LOCAL_CONF" >> "$USERPREFS"
      fi
    '';
  };
}
