{ config, pkgs, ... }:
{
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-cachyos-kernel.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-cachyos-kernel.cachix.org-1:YTix2hFmNPDYBEaKSLAFKiX3C1FGqKlC3/eJzB87ZYI="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    fastfetch
  ];

  system.stateVersion = "24.11";
}
