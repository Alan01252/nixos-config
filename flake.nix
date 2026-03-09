{


   inputs = {
      nixpkgs.url = "nixpkgs/nixos-25.05";
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      codex-cli-nix.url = "github:sadjow/codex-cli-nix/387560b19729bfdb01dad9a12b46ec6e75286cca";
      claude-desktop = {
        url = "github:k3d3/claude-desktop-linux-flake";
        inputs.nixpkgs.follows    = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
      };
      ai-assistant = {
	  url = "path:/home/alan/Workspace/alan/ai-assistant";
	  inputs.nixpkgs.follows = "nixpkgs";
      };
      stlink.url = "path:/home/alan/Workspace/rugged-networks/stlink";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, codex-cli-nix, claude-desktop, ai-assistant, stlink }:

  let 
    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
	config.allowUnfree = true;
 	config.permittedInsecurePackages = [
            "dotnet-sdk-6.0.428" "dotnet-runtime-6.0.36"
          ];
        overlays = [  ];
      };
    };


    claudeOverlay = (final: prev: {
              claudeDesktopFhs = claude-desktop.packages.x86_64-linux.claude-desktop-with-fhs;
            });

    codexOverlay = final: prev: {
      codex = (codex-cli-nix.packages.${final.system}.default).overrideAttrs (old: {
        # Ensure libcap is present and on the runtime rpath.
        buildInputs = (old.buildInputs or []) ++ [ final.libcap ];
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final.patchelf final.file ];
        postFixup = (old.postFixup or "") + ''
          if [ -x "$out/bin/codex-raw" ]; then
            if file "$out/bin/codex-raw" | grep -q 'ELF'; then
              patchelf --add-rpath "${final.lib.makeLibraryPath [ final.libcap ]}" "$out/bin/codex-raw"
            fi
          fi
        '';
      });
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
             overlays = [ unstableOverlay openvpnOverlay claudeOverlay codexOverlay ];
             config.allowUnfree = true; 
 config.permittedInsecurePackages = [
                "dotnet-sdk-6.0.428" "dotnet-runtime-6.0.36"

              ];



           };
         })
	./configuration.nix 
       ];
    };
  };
}
