{
  description = "Marwin's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substitutors = [
      #      "https://hyprland.cachix.org"
      "https://app.cachix.org/cache/jakestanger"
      "https://cache.nixos.org/"
    ];
    extra-substitutors = [
      # community cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixstable.url = "nixpkgs/nixos-23.11";
    nixmaster.url = "nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-nix-config.url = "github:MarwinKreuzig/nvim-nix-config";
    #   hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };

  outputs = { self, nixpkgs, nixstable, nixmaster, home-manager, ... }@inputs:
    let
      mkSystem = { host, uses-nvidia, module }:
        let
          system = "x86_64-linux";
          nixpkgs-stable = import nixstable { inherit system; config.allowUnfree = true; };
          nixpkgs-master = import nixmaster { inherit system; config.allowUnfree = true; };
        in
        nixpkgs.lib.nixosSystem
          {
            inherit system;
            specialArgs = { inherit inputs nixpkgs-stable nixpkgs-master host uses-nvidia; };
            modules = [
              ./hosts/common
              module

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs self nixpkgs-stable nixpkgs-master uses-nvidia host; };
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
