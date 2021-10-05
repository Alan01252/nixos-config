{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "flux2";
  src = pkgs.fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v0.16.1/flux_0.16.1_linux_amd64.tar.gz";
    sha256 = "09pj97sklj4ryv2jppba1gj142rv1qlmy36bd705ym0wb7n3ym9b";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/flux $out/bin/flux
    chmod +x $out/bin/flux
  '';

}
