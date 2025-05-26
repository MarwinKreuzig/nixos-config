{
  description = "Marwin's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substitutors = [
      "https://app.cachix.org/cache/jakestanger"
      "https://cache.nixos.org/"
    ];
    extra-substitutors = [
      # community cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
    ];
  };

  inputs = {
    # nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/8a2f738d9d1f1d986b5a4cd2fd2061a7127237d7";
    home-manager = {
      # use the line with the branch when you are getting an error because of a version mismatch
      # url = "github:nix-community/home-manager/release-25.11";
      url = "github:nix-community/home-manager/d31710fb2cd536b1966fee2af74e99a0816a61a8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-nix-config.url = "github:MarwinKreuzig/nvim-nix-config";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      mkSystem = { host, uses-nvidia, module }:
        let
          system = "x86_64-linux";
          # pkgs-master = import nixpkgs-master { inherit system; config.allowUnfree = true; };
          specialArgs = { inherit inputs host uses-nvidia; };
        in
        nixpkgs.lib.nixosSystem
          {
            inherit system specialArgs;
            modules = [
              ./hosts/common
              module

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users.marwin = ./marwin;
                  backupFileExtension = ".hm-auto-backup";
                };
              }
            ];
          };

    in
    {
      nixosConfigurations = {
        "marwindesktopnixos" = mkSystem { host = "desktop"; uses-nvidia = true; module = import ./hosts/desktop; };
        "marwinlaptop0nixos" = mkSystem { host = "laptop0"; uses-nvidia = false; module = import ./hosts/laptop0; };
      };
    };
}
