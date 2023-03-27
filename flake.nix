{


   inputs = {
      nixpkgs.url = "nixpkgs/nixos-22.11";
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: 
  let 
    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
	config.allowUnfree = true;
      };
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.channels = { inherit nixpkgs nixpkgs-unstable; };
      modules = [ 
         ({
           nixpkgs = {
             overlays = [ unstableOverlay ];
             config.allowUnfree = true; 
           };
         })
	./configuration.nix 
       ];
    };
  };
}

