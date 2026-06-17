{ config, pkgs, ... }:
{

  hardware.graphics.enable32Bit = true;

  # EasyEffects for audio DSP
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    easyeffects
  ];
}
