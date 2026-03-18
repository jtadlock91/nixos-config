{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    settings = {
      shell_integration = "enabled";
    };
  };

  # Fastfetch runs every time a new shell opens in Kitty
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -n "$KITTY_WINDOW_ID" ]; then
        fastfetch
      fi
    '';
  };
}
