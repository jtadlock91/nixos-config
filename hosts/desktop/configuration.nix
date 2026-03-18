{ config, pkgs, nix-cachyos-kernel, ... }:

let
  useCachyKernel = true;
  cachyKernel =
    nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-rc-lto;
  fallbackKernel = pkgs.linuxPackages_latest;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/performance.nix
  ];

  networking.hostName = "nixos-desktop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = if useCachyKernel then cachyKernel else fallbackKernel;
  boot.loader.systemd-boot.configurationLimit = 5;

  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  hardware.bluetooth.enable = false;

  # btrfs compression and trim
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
}
