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
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -n "$KITTY_WINDOW_ID" ]; then
        fastfetch
      fi
      alias update='cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname) && git add flake.lock && git commit -m "chore: update flake inputs" && git push'
    '';
  };
}
