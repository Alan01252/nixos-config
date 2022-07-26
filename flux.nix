{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "flux2";
  src = pkgs.fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v0.28.5/flux_0.28.5_linux_amd64.tar.gz";
    sha256 = "sha256-IIK5yNj3kbpKhrNF65ESiYgadgAcsvK5BFXxbwkdvHg=";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/flux $out/bin/flux
    chmod +x $out/bin/flux
  '';

}
