{ stdenv , wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "csharp";
      publisher = "ms-dotnettools";
      version = "1.21.17";
      sha256 = "05v6ksqng50am88h4qgsp01ni126m0v1n7wxgyask332njg971q8";
    };

    postInstall = ''
      mkdir -p $out/share/vscode/extensions/ms-vscode.csharp/.omnisharp/1.34.11/
      touch $out/share/vscode/extensions/ms-vscode.csharp/.omnisharp/1.34.11/install.Lock
      mkdir -p $out/share/vscode/extensions/ms-vscode.csharp/.debugger/
      touch $out/share/vscode/extensions/ms-vscode.csharp/.debugger/install.Lock
      mkdir -p $out/share/vscode/extensions/ms-vscode.csharp/.razor/
      touch $out/share/vscode/extensions/ms-vscode.csharp/.razor/install.Lock
	
    '';

    meta = with stdenv.lib; {
      description = ''
      '';
    };
  }
