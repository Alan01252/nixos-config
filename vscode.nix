{ pkgs }:
let


  ms-vscode-csharp = pkgs.callPackage ./ms-vscode-csharp.nix {};

  vscode = pkgs.callPackage /home/alan/Workspace/alan/nixpkgs/pkgs/applications/editors/vscode/with-extensions.nix {

      vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.Nix
	  ms-vscode-csharp
          ms-vscode.cpptools 
      ]
      ++
      pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	{
	  name = "vim";
	  publisher = "vscodevim";
          version = "1.14.5";
          sha256 = "1a4r07xijrnz7bxkkpl2njwv2128hcwvmqvmirw4v41paw559231";
	}
	{
	  name = "Go";
	  publisher = "ms-vscode";
          version = "0.13.1";
          sha256 = "18x89g4b085crfm1wnfnsznwlvc30xqcivzf5nw9d1z5rg2dva5h";
	}

        {
	  name = "python";
	  publisher = "ms-python";
          version = "2020.9.112786";
          sha256 = "0n7sgx8k9zrdrl4iqvhyqizi7ak0z6vva3paryfd7rivp0g3caw4";
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
	  publisher = "HashiCorp";
          version = "2.4.0";
          sha256 = "14waz0yv25f4l46y84px2g58qnawbzp1p24zrfjqlxmp99kx009n";
	}
	{
	  name = "code-spell-checker";
	  publisher = "streetsidesoftware";
          version = "1.4.0";
          sha256 = "0cjhglyqrwvi0b1pw20idi1z1q6fq3yv98kvr433d76p9bzz3fkj";
	}
        {
	  name = "vscode-kubernetes-tools";
	  publisher = "ms-kubernetes-tools";
          version = "1.2.1";
          sha256 = "071p27xcq77vbpnmb83pjsnng7h97q4gai0k6qgwg3ygv086hpf4";
	}
	{
	  name = "vscode-yaml";
	  publisher = "redhat";
          version = "0.10.1";
          sha256 = "0l37qwppy5dhva8qrhhnnf7y4pxhgssxfk8rkh30r7xvnk96707x";
	}
	{
	  name = "vscode-pylance";
	  publisher = "ms-python";
          version = "2020.9.7";
          sha256 = "1cf41bcvry0zhbrhd2yf4h5ymdwr56xgdns9fg3cc3vjnnq03rzq";
	}
	{
	  name = "nix-env-selector";
	  publisher = "arrterian";
          version = "0.1.2";
          sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
	}
	{
	  name = "jinjahtml";
	  publisher = "samuelcolvin";
          version = "0.15.0";
          sha256 = "18mjabpzldsaz5r1sp94kwk28chrmifcr4aql0fag6yh2kms1jas";
	}
	{
	  name = "nix-ide";
	  publisher = "jnoortheen";
          version = "0.1.3";
          sha256 = "1c2yljzjka17hr213hiqad58spk93c6q6xcxvbnahhrdfvggy8al";
	}
     ];

  };
in 
  vscode
