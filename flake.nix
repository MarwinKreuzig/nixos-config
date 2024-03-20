{
  description = "Marwin's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substitutors = [
      "https://hyprland.cachix.org"
      "https://app.cachix.org/cache/jakestanger"
      "https://cache.nixos.org/"
    ];
    extra-substitutors = [
      # community cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixstable.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixstable, home-manager, ... }@inputs: 
    let mkSystem = { de-config, uses-nvidia, module }: 
    let system =  "x86_64-linux"; 
        nixpkgs-stable = import nixstable { inherit system; };
    in nixpkgs.lib.nixosSystem 
        {
        inherit system;
        specialArgs = { inherit inputs nixpkgs-stable; uses-nvidia = true; de-config = "desktop"; };
        modules = [
          ./hosts/common
          module

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs self nixpkgs-stable; uses-nvidia = true; de-config = "desktop"; };
              users.marwin = import ./home/default.nix;
            };
          }
        ];
      };

  in {
    nixosConfigurations = {
      "desktop" = mkSystem { de-config = "desktop"; uses-nvidia = true; module = import ./hosts/desktop; };
      "laptop0" = mkSystem { de-config = "laptop0"; uses-nvidia = false; module = import ./hosts/laptop0; };
    };
  };
}
