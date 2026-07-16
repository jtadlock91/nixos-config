{ config, pkgs, ... }:
{
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Enable SSH so we can always get in remotely
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

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
    connect-timeout = 5;
    fallback = true;
    substituters = [
      
      "https://attic.xuyh0120.win/lantian"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2d";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  users.groups.john = {};
  users.users.john = {
    group = "john";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
  };

  # Set a password for john so SSH login works
  users.users.john.initialPassword = "nixos";

  environment.variables = {
    BROWSER = "vivaldi";
    EDITOR = "nano";
  };

  environment.systemPackages = with pkgs; [
    clamav
    clamtk
    haruna
    mpv
    git
    wget
    htop
    fastfetch
  ];

  system.stateVersion = "24.11";
}
