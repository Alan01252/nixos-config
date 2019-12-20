{ pkgs ? import <nixpkgs> {}}:
let
  vscode = pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.Nix
      ]
      ++
      pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	{
	  name = "vim";
	  publisher = "vscodevim";
	  version = "1.12.0";
          sha256 = "113l9sm7xlb4bv5bhc4avdf7ngmwfx90ikf3xx6abnhignkc3fbi";
	}
	{
	  name = "csharp";
	  publisher = "ms-vscode";
	  version = "1.21.9";
          sha256 = "14qn57hkw83wbafp9bpz4p7s0hia91c6hh7yc63j5br15av92ffj";
	}
      ];
  };
in 
  vscode
