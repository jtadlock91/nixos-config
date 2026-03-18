# Placeholder — replaced by nixos-generate-config during install
{ config, pkgs, ... }:
{
  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usb_storage" ];
}
