{ pkgs ? import <nixpkgs> {}}:

let

  dotNetCombined = pkgs.recurseIntoAttrs (pkgs.callPackage ./dotnet {});

  dotNet = with dotNetCombined; combinePackages {
    packages = [
    	sdk_3_1
   ];
  };

in
  dotNet
