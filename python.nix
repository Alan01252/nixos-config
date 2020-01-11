{ pkgs ? import <nixpkgs> {}}:


let

  my-python-packages = pkgs.python3.withPackages(ps: with ps; [
	black
        netaddr
        aiohttp 
  ]);
in
  my-python-packages
