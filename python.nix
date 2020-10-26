{ pkgs ? import <nixpkgs> {}}:


let

  my-python-packages = pkgs.python3.withPackages(ps: with ps; [
	black
        netaddr
        aiohttp 
	scapy
	requests
        pylint
  ]);
in
  my-python-packages
