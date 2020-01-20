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
 	{
	  name = "dotnet-test-explorer";
	  publisher = "formulahendry";
          version = "0.7.1";
          sha256 = "1v80dclx4l8iza27d0d5ybfywdz3rid07h05rs0hwpiyfpb23pw8";
	}
	{
	  name = "vscode-coverage-gutters";
	  publisher = "ryanluker";
          version = "2.4.2";
          sha256 = "1351ix5vp1asny6c2dihf8n18gdqsg5862z6wx2b5yflvslsqjx2";
	}
	{
	  name = "terraform";
	  publisher = "mauve";
          version = "1.4.0";
          sha256 = "0b3cqxaay85ab10x1cg7622rryf4di4d35zq9nqcjg584k6jjb34";
	}
	{
	  name = "code-spell-checker";
	  publisher = "streetsidesoftware";
          version = "1.4.0";
          sha256 = "0cjhglyqrwvi0b1pw20idi1z1q6fq3yv98kvr433d76p9bzz3fkj";
	}

     ];
  };
in 
  vscode
