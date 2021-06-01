{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "flux2";
  src = pkgs.fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v0.13.4/flux_0.13.4_linux_amd64.tar.gz";
    sha256 = "0cy03li8nn41pbg8sjx8gmwlx289s3mpc1qg23viawa60xb8cd5y";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/flux $out/bin/flux
    chmod +x $out/bin/flux
  '';

}
