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
      update() {
        local flake_target
        case "$(hostname)" in
          nixos-desktop) flake_target="desktop" ;;
          *)             flake_target="laptop" ;;
        esac
        cd ~/nixos-config || return 1
        if ! git pull; then
          if git status --porcelain | grep -q '^UU flake.lock$' \
             && [ "$(git status --porcelain | grep -c '^UU')" -eq 1 ]; then
            echo "==> flake.lock conflict detected during pull -- auto-resolving"
            git checkout --theirs flake.lock
            git add flake.lock
            git rebase --continue
          else
            echo "==> Pull failed with a conflict outside flake.lock -- stopping for manual review"
            git status
            return 1
          fi
        fi
        nix flake update
        echo "==> Rebuilding #''${flake_target}"
        if ! sudo nixos-rebuild switch --flake ~/nixos-config#"''${flake_target}"; then
          echo "==> Rebuild failed -- not committing/pushing flake.lock"
          return 1
        fi
        sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system
        sudo nix-collect-garbage
        git add flake.lock
        git commit -m "chore: update flake inputs"
        if ! git push; then
          echo "==> Push rejected -- retrying pull+resolve"
          if ! git pull; then
            if git status --porcelain | grep -q '^UU flake.lock$' \
               && [ "$(git status --porcelain | grep -c '^UU')" -eq 1 ]; then
              git checkout --theirs flake.lock
              git add flake.lock
              git rebase --continue
              nix flake update
              git add flake.lock
              git commit -m "chore: update flake inputs" --amend --no-edit
            else
              echo "==> Conflict outside flake.lock on retry -- stopping for manual review"
              git status
              return 1
            fi
          fi
          git push
        fi
      }
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
