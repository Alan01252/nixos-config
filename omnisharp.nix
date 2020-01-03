{ pkgs ? import <nixpkgs> {}}:
let
  omnisharp = pkgs.omnisharp-roslyn.overrideAttrs (oldAttrs: rec {
  version = "1.34.9";
  pname = "omnisharp-roslyn";

  src = pkgs.fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "1b5jzc7dj9hhddrr73hhpq95h8vabkd6xac1bwq05lb24m0jsrp9";
  };

  });

in 
  omnisharp
