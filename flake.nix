{


   inputs = {
      nixpkgs.url = "nixpkgs/nixos-23.11";
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


    openvpnOverlay = final: prev: {
      openvpn = prev.openvpn.overrideAttrs (oldAttrs: {
        version = "2.6.4";
        buildInputs = oldAttrs.buildInputs ++ [ prev.libnl prev.libcap_ng prev.lz4 ];
        src = prev.fetchurl {
          url = "https://swupdate.openvpn.org/community/releases/openvpn-2.6.4.tar.gz";
          sha256 = "NxoqMjqZp5KZubTKpKMbx7LN/2MjbmjUKfPuUOdfPdQ=";  # Remember to update this
        };
      });
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.channels = { inherit nixpkgs nixpkgs-unstable; };
      modules = [ 
         ({
           nixpkgs = {
             overlays = [ unstableOverlay openvpnOverlay ];
             config.allowUnfree = true; 
           };
         })
	./configuration.nix 
       ];
    };
  };
}

