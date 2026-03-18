{ config, pkgs, nix-cachyos-kernel, ... }:

let
  useCachyKernel = true;
  cachyKernel =
    nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-rc;
  fallbackKernel = pkgs.linuxPackages_latest;
in
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-laptop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = if useCachyKernel then cachyKernel else fallbackKernel;
  boot.loader.systemd-boot.configurationLimit = 5;

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # TLP conflicts with power-profiles-daemon which KDE enables by default
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
}
