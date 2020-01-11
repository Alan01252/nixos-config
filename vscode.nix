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
          version = "1.12.2";
          sha256 = "1a4r07xijrnz7bxkkpl2njwv2128hcwvmqvmirw4v41paw559231";
	}
	{
	  name = "csharp";
	  publisher = "ms-vscode";
	  version = "1.21.9";
          sha256 = "14qn57hkw83wbafp9bpz4p7s0hia91c6hh7yc63j5br15av92ffj";
	}
        {
	  name = "python";
	  publisher = "ms-python";
          version = "2019.11.50794";
          sha256 = "1imc4gc3aq5x6prb8fxz70v4l838h22hfq2f8an4mldyragdz7ka";
	}
	{
	  name = "vscode-docker";
	  publisher = "ms-azuretools";
          version = "0.9.0";
          sha256 = "0wka4sgq5xjgqq2dc3zimrdcbl9166lavscz7zm6v4n6f9s2pfj0";
	}
      ];
  };
in 
  vscode
