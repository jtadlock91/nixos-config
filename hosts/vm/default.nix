{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "nixos-vm";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.qemuGuest.enable = true;
  services.openssh.enable = true;
  hardware.bluetooth.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [ git ];

  # VM user — installer created workpc, not john
  users.users.workpc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
    initialPassword = "nixos";
  };
}
