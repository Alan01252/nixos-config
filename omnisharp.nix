{ pkgs ? import <nixpkgs> {}}:
let
  omnisharp = pkgs.omnisharp-roslyn.overrideAttrs (oldAttrs: rec {
  version = "1.34.13";
  pname = "omnisharp-roslyn";

  src = pkgs.fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "0558w3wjb5pzb7pyn1zjk5zb3ih62k3a972d7nxgc4pfqlcqsky8";
  };

  });

in 
  omnisharp
