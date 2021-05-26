{ pkgs ? import <nixpkgs> {}}:
let
  bcc = pkgs.linuxPackages.bcc.overrideAttrs (oldAttrs: rec {
  version = "0.12.0";
  name = "bcc-0.12.0";

  srcs = [
    (pkgs.fetchFromGitHub {
      owner  = "iovisor";
      repo   = "bcc";
      rev    = "v${version}";
      sha256 = "0f5jx10s5n1p7wpbdir70m5swgvymsv136qdzq2gp34yy22alhsy";
      name   = "bcc";
    })

    # note: keep this in sync with the version that was used at the time of the
    # tagged release!
    (pkgs.fetchFromGitHub {
      owner  = "libbpf";
      repo   = "libbpf";
      rev    = "a30df5c09fb3941fc42c4570ed2545e7057bf82a";
      sha256 = "0x82iyzq37rm7r961arivgfm099n0sxwrqibmkwnbwkq74xw20z1";
      name   = "libbpf";
    })
  ];

  cmakeFlags = [
    "-DBCC_KERNEL_MODULES_DIR=/nix/store/mpl6pr6rdpzysvivprd6p0yglm6rm6lx-linux-5.4.6-dev/lib/modules"
    "-DREVISION=${version}"
    "-DENABLE_USDT=ON"
    "-DENABLE_CPP_API=ON"
  ];


  });

in 
  bcc
