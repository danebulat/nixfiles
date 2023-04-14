{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {

	# System configuration
	# sudo nixos-rebuild switch --flake .<hash>dane

        # To update a flake:
        # nix flake update #--recreate-lock-file

        dane = lib.nixosSystem {
          inherit system;
	  modules = [ 
	    ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.dane = {
                imports = [ ./home.nix ];
	      };
	    }
	  ];
	};
      };


      # Sample home-manager configuration
      # nix build .#hmConfig.dane.activationsPackage
      homeConfigurations.dane = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        #username = "dane";
        #homeDirectory = "/home/dane";

        # If there is any complaining about differing 
        #stateVersion, specifically state here. 
        #stateVersion = "22.11";
      
        modules = [
          ./home.nix
        ];
      };
    };
}
