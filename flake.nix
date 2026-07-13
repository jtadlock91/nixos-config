{
  description = "NixOS config — desktop (AMD 9900X + RX9060XT) & laptop (Intel + NVIDIA)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
    };
   claude-desktop-bin = {
     url = "github:patrickjaja/claude-desktop-bin";
   };
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, claude-desktop-bin, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nix-cachyos-kernel claude-desktop-bin; };
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/common.nix
          ./modules/kde.nix
          ./modules/gaming.nix
          ./modules/performance.nix
          { nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.john = import ./home;
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nix-cachyos-kernel; };
        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/common.nix
          ./modules/kde.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.worklaptop = import ./home;
          }
        ];
      };

    };
  };
}
