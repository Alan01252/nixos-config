{ pkgs ? import <nixpkgs> {}}:
let
  omnisharp = pkgs.omnisharp-roslyn.overrideAttrs (oldAttrs: rec {
  version = "1.37.8";
  pname = "omnisharp-roslyn";

  src = pkgs.fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-linux-x64.tar.gz";
    sha256 = "08hvz33xicwyq9xqy7z44bvbr5shkg30fl9y0rkbbh9hjlwdn3ym";
  };

  });

in 
  omnisharp
