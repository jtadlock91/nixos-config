{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
  };

  hardware.graphics.enable32Bit = true;

  # EasyEffects for audio DSP
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    easyeffects
  ];
}
