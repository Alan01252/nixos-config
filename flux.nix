{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "flux2";
  src = pkgs.fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v0.23.0/flux_0.23.0_linux_amd64.tar.gz";
    sha256 = "eax9N/bxbm0k25d1RCfgRnQUbE4Wi+QyajlFG8xd5GE=";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/flux $out/bin/flux
    chmod +x $out/bin/flux
  '';

}
