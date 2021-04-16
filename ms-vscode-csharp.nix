{ stdenv , unzip, fetchurl, wakatime, vscode-utils, autoPatchelfHook, glibc, gcc-unwrapped, curl, icu, openssl }:

let

  debugger = stdenv.mkDerivation {
    name = "vs-code-debugger";
    src = fetchurl {
     url = "https://download.visualstudio.microsoft.com/download/pr/292d2e01-fb93-455f-a6b3-76cddad4f1ef/2e9b8bc5431d8f6c56025e76eaabbdff/coreclr-debug-linux-x64.zip";
     sha256 = "1lhyjq6g6lc1b4n4z57g0ssr5msqgsmrl8yli8j9ah5s3jq1lrda";
    };

    nativeBuildInputs = [
      unzip
      autoPatchelfHook
    ];

    buildInputs = [
     glibc
     gcc-unwrapped
     curl
     openssl
    ];

    unpackPhase = ''
     unzip $src
    '';


    installPhase = ''
      mkdir -p "$out/"
      mv * $out/
      chmod a+x $out/vsdbg-ui
      chmod a+x $out/vsdbg
      touch $out/install.Lock
    '';
  };

  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {

    inherit debugger;

    mktplcRef = {
      name = "csharp";
      publisher = "ms-dotnettools";
      version = "1.23.9";
      sha256 = "1609yxa6h5db8hknqz12f3l8wh71lfv8ngw1yzxs6smkxbfywvg4";
    };

    postInstall = ''
      mkdir -p $out/share/vscode/extensions/ms-dotnettools.csharp/.omnisharp/1.37.6/
      touch $out/share/vscode/extensions/ms-dotnettools.csharp/.omnisharp/1.37.6/install.Lock
      ln -s $debugger $out/share/vscode/extensions/ms-dotnettools.csharp/.debugger
      mkdir -p $out/share/vscode/extensions/ms-dotnettools.csharp/.razor/
      touch $out/share/vscode/extensions/ms-dotnettools.csharp/.razor/install.Lock
      mkdir -p $out/share/vscode/extensions/ms-dotnettools.csharp/.debugger/
    '';

    meta = with stdenv.lib; {
      description = ''
      '';
    };
  }
