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
      if [ "$(hostname)" = "nixos-desktop" ]; then
        alias update='cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#desktop && git add flake.lock && git commit -m "chore: update flake inputs" && git push'
      else
        alias update='cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#laptop && git add flake.lock && git commit -m "chore: update flake inputs" && git push'
      fi
    '';
  };
}
