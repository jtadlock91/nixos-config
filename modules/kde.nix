{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  services.displayManager.plasma-login-manager.enable = true;

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kdepim-runtime
    kmahjongg
    kmines
    konversation
    kpat
    ksudoku
    ktorrent
    plasma-browser-integration
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    DISPLAY = ":0";
  };

  environment.systemPackages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs
    kitty
    kdePackages.krohnkite    # dynamic tiling for KWin 6
  ];
}
