{ nixpkgs, user, home-manager }:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib;
in
  {
    # System configuration
    # sudo nixos-rebuild switch --flake .<hash>dane
    
    # To update a flake:
    # nix flake update #--recreate-lock-file

    dane = lib.nixosSystem {
      inherit system;

      modules = [
	# Imports hardware-configuration.nix 
        ./configuration.nix

        # Home manager
	home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.dane = {
            imports = [ 
	      ./home.nix 
	    ];
	  };
	}
      ];
    };

  }

