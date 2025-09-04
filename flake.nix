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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      # use the line with the branch when you are getting an error because of a version mismatch
      # url = "github:nix-community/home-manager/release-25.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-nix-config.url = "github:MarwinKreuzig/nvim-nix-config";
    mcsr.url = "github:MarwinKreuzig/mcsr-flake";
    mcsr.inputs.nixpkgs.follows = "nixpkgs";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
  };


  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      mkSystem = { users, host, }: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/host-modules.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              backupFileExtension = ".hm-auto-backup";
              users = nixpkgs.lib.mapAttrs
                (username: userConfig:
                  {
                    imports = [
                      ./modules/home-modules.nix
                      userConfig
                    ];
                    config = {
                      home = {
                        inherit username;
                        homeDirectory = "/home/${username}";
                      };
                      programs.home-manager.enable = true;
                    };
                  }
                )
                users;
            };
          }
          host
        ];
      };
    in
    {
      nixosConfigurations = {
        "desktop0" = mkSystem { };
        "desktop1" = mkSystem {
          users.marwin = ./hosts/desktop1/users/marwin;
          host = ./hosts/desktop1;
        };
        "laptop0" = mkSystem {
          users.marwin = ./hosts/laptop0/users/marwin;
          host = ./hosts/laptop0;
        };
      };
    };
}
