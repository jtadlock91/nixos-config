{ config, pkgs, nix-cachyos-kernel, claude-desktop-bin, ... }:

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

 nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = if useCachyKernel then cachyKernel else fallbackKernel;
  boot.loader.systemd-boot.configurationLimit = 5;

  hardware.cpu.amd.updateMicrocode = true;
 boot.kernelModules = [ "kvm-amd" ];

  environment.systemPackages = (with pkgs; [ rustdesk ]) ++ [ claude-desktop-bin.packages.${pkgs.system}.default ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
  };

  # AMD P-state driver
  boot.kernelParams = [ "amd_pstate=guided" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "gpl,nggc";
    mesa_glthread = "true";
  };

  hardware.bluetooth.enable = false;

 users.users.john.extraGroups = [ "kvm" ];

}
