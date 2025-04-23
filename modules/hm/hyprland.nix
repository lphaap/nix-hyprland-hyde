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
    # Create the local.conf file with keyboard settings
    home.file.".config/hypr/local.conf" = { 
      text = ''
      # Your existing system config plus your keyboard settings
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
      force = true;
      mutable = true;
    };
    
    # Fix the activation script to be more resilient
    home.activation.ensureHyprlandLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Ensuring local.conf is sourced in Hyprland configuration"
      
      # Make sure hyprland.conf exists before trying to modify it
      MAIN_CONFIG="$HOME/.config/hypr/hyprland.conf"
      SOURCE_LINE="source = ~/.config/hypr/local.conf"
      
      if [ ! -f "$MAIN_CONFIG" ]; then
        echo "Warning: $MAIN_CONFIG doesn't exist yet, creating it"
        mkdir -p "$(dirname "$MAIN_CONFIG")"
        echo "# Hyprland Configuration" > "$MAIN_CONFIG"
        echo "$SOURCE_LINE" >> "$MAIN_CONFIG"
      elif ! grep -q "$SOURCE_LINE" "$MAIN_CONFIG"; then
        echo "Adding source line for local.conf to hyprland.conf"
        # Use tee for better error handling than direct redirection
        echo "$SOURCE_LINE" | tee -a "$MAIN_CONFIG" >/dev/null
      else
        echo "local.conf already sourced in hyprland.conf"
      fi
      
      # Make sure our configuration is applied one way or another
      echo "Creating keyboard configuration script as fallback"
      mkdir -p "$HOME/.config/hypr/scripts"
      cat > "$HOME/.config/hypr/scripts/set-keyboard.sh" << 'EOF'
#!/bin/sh
sleep 1
hyprctl keyword input:kb_layout fi
hyprctl keyword input:kb_options caps:escape
EOF
      chmod +x "$HOME/.config/hypr/scripts/set-keyboard.sh"
      
      # Add to autostart if not already there
      mkdir -p "$HOME/.config/hypr/autostart.d"
      if [ ! -f "$HOME/.config/hypr/autostart.d/keyboard.conf" ]; then
        echo "exec-once = ~/.config/hypr/scripts/set-keyboard.sh" > "$HOME/.config/hypr/autostart.d/keyboard.conf"
      fi
      
      # Success regardless of what happened above
      exit 0
    '';
  };
}
