{ pkgs }:
let


  ms-vscode-csharp = pkgs.callPackage ./ms-vscode-csharp.nix {};

  vscode = pkgs.callPackage /home/alan/Workspace/alan/nixpkgs/pkgs/applications/editors/vscode/with-extensions.nix {

      vscodeExtensions = with pkgs.vscode-extensions; [
	  ms-vscode-csharp
          ms-vscode.cpptools 
      ]
      ++
      pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	{
	  name = "vim";
	  publisher = "vscodevim";
          version = "1.21.1";
          sha256 = "1zw9q3jaypw5db8h4fcrwabxvnm5pnb9mjyqwgprpkrd2vw5lvwi";
	}
        {
	  name = "python";
	  publisher = "ms-python";
          version = "2021.9.1246542782";
          sha256 = "105vj20749bck6ijdlf7hsg5nb82bi5pklf80l1s7fn4ajr2yk02";
	}
	{
	  name = "vscode-docker";
	  publisher = "ms-azuretools";
          version = "1.17.0";
          sha256 = "01na7j64mavn2zqfxkly9n6fpr6bs3vyiipy09jkmr5m86fq0cdx";
	}
 	{
	  name = "dotnet-test-explorer";
	  publisher = "formulahendry";
          version = "0.7.7";
          sha256 = "0h8lhsz993wzy4am0dgb0318mfrc5isywcxi0k4nakzj0dkk3w6y";
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
          version = "2.15.0";
          sha256 = "0bqf9ry0idqw61714dc6y1rh5js35mi14q19yqhiwayyfakwraq9";
	}
	{
	  name = "code-spell-checker";
	  publisher = "streetsidesoftware";
          version = "2.0.8";
          sha256 = "165yfw25z9rdcb3qbc38gfgs88mmam8m4sa3sq3g0fsapipar5cr";
	}
        {
	  name = "vscode-kubernetes-tools";
	  publisher = "ms-kubernetes-tools";
          version = "1.3.3";
          sha256 = "1w22wyqszizcmr6qw0d5hqg64455yphzjjq6w13izc2flpird1kl";
	}
	{
	  name = "vscode-yaml";
	  publisher = "redhat";
          version = "0.23.0";
          sha256 = "0hdly0cxj13fs5q06nlcic3yhv6jq641q01y07sxl9xaprb0n2dm";
	}
	{
	  name = "vscode-pylance";
	  publisher = "ms-python";
          version = "2021.9.4";
          sha256 = "1579h6zfrws55xh7cz4lg7p5j7r5awrlhk7b49mr3781q980zqbr";
	}
	{
	  name = "nix-env-selector";
	  publisher = "arrterian";
          version = "1.0.7";
          sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
	}
	{
	  name = "jinjahtml";
	  publisher = "samuelcolvin";
          version = "0.16.0";
          sha256 = "17f4dzwsqpwdkzc9f35sx31mvb4zns2ya0ym7mjgl8iy1kyci66q";
	}
	{
	  name = "nix-ide";
	  publisher = "jnoortheen";
          version = "0.1.16";
          sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
	}
        {
	  name = "aws-toolkit-vscode";
	  publisher = "amazonwebservices";
          version = "1.30.0";
          sha256 = "1w77mi94xbm4fmsbxjq607f5yhh4z9g0d8g1z27c8g9lzqjf75g2";
	}
	{
	  name = "Go";
	  publisher = "golang";
          version = "0.28.1";
          sha256 = "1fiycdss64izdxk7gnp1gx6bdl040cr5lk17cnb2p30qpgpjv0gz";
	}

     ];

  };
in 
  vscode
