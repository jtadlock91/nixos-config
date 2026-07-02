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
 boot.kernelModules = [ "kvm-amd" "vhost_vsock" ];

  environment.systemPackages = (with pkgs; [ rustdesk ]) ++ [ (claude-desktop-bin.packages.${pkgs.system}.default.override { qemu = pkgs.qemu; }) ];

  # Cowork VM support (claude-desktop-bin) — OVMF at a path the app probes
  systemd.tmpfiles.rules = [
    "d /usr/share/edk2 0755 root root -"
    "d /usr/share/edk2/x64 0755 root root -"
    "L+ /usr/share/edk2/x64/OVMF_CODE.fd - - - - ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd"
    "L+ /usr/share/edk2/x64/OVMF_VARS.fd - - - - ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd"
  ];

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
