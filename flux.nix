{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "flux2";
  src = pkgs.fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v0.21.0/flux_0.21.0_linux_amd64.tar.gz";
    sha256 = "0087ffgxmn0i8g74kchra9sr25js1nw8cjpxsfzq62h1wr34y0qx";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/flux $out/bin/flux
    chmod +x $out/bin/flux
  '';

}
