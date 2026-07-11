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
        alias update='cd ~/nixos-config && git pull && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#desktop && sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && git add flake.lock && git commit -m "chore: update flake inputs" && git push'
      else
        alias update='cd ~/nixos-config && git pull && nix flake update && sudo nixos-rebuild switch --flake ~/nixos-config#laptop && sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && git add flake.lock && git commit -m "chore: update flake inputs" && git push'
      fi
      rebuild() {
        local action="''${1:-switch}"
        local target
        case "$(hostname)" in
          nixos-desktop) target="desktop" ;;
          nixos-laptop)  target="laptop" ;;
          *)
            echo "Unknown hostname '$(hostname)' -- refusing to guess a flake target."
            return 1
            ;;
        esac
        echo "Building #$target for host $(hostname) (action: $action)"
        sudo nixos-rebuild "$action" --flake ~/nixos-config#"$target"
      }

     alias deploy-site='cd ~/pcrepair-website && git pull && scp index.html root@192.168.100.102:/data/arrconfig/pcrepair/index.html && cd -'
    '';
  };
}
