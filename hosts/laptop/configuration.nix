{ config, pkgs, nix-cachyos-kernel, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/performance.nix
  ];

  networking.hostName = "nixos-laptop";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  services.tlp.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = false;
  services.power-profiles-daemon.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  users.groups.worklaptop = {};
  users.users.worklaptop = {
    isNormalUser = true;
    group = "worklaptop";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
    initialPassword = "nixos";
  };

}
