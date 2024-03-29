{ pkgs }:
let


  ms-vscode-csharp = pkgs.callPackage ./ms-vscode-csharp.nix { };

  extensions = (with pkgs.vscode-extensions; [
    ms-vscode-csharp
    ms-vscode-remote.remote-ssh
  ])
  ++
  pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vim";
      publisher = "vscodevim";
      version = "1.21.10";
      sha256 = "NiwIS+Soux5cyyEXXI5CCuJBJCRtYD7hkN/VKVg9NTE=";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.226.0";
      sha256 = "6GGU89kqD/7hd/zp+ZfeBn6CbkUirsNS5opL9Nd+OqQ=";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2023.7.10881020";
      sha256 = "sha256-5NqgYonHbNFu6W/Ue68AXGJ7nAC98c8w8q3CVVbrygs=";
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
      version = "2.17.0";
      sha256 = "IZlw1lYibbBw3rcSiWEKP8rObxnMCE1ppogwmigNgwE=";
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
      version = "1.3.4";
      sha256 = "LXcIwE+sL7ZJU6dsJkrko4CzQb6T+FcgL6OC+iQtVEU=";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "1.2.2";
      sha256 = "pjNe+0mppY+ionTHDP9lVVllWx6zyaStjxXTkXF3xBo=";
    }
    {
      name = "vscode-pylance";
      publisher = "ms-python";
      version = "2021.9.4";
      sha256 = "1579h6zfrws55xh7cz4lg7p5j7r5awrlhk7b49mr3781q980zqbr";
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
    {
      name = "direnv";
      publisher = "mkhl";
      version = "0.14.0";
      sha256 = "T+bt6ku+zkqzP1gXNLcpjtFAevDRiSKnZaE7sM4pUOs=";
    }
    {
      name = "shellcheck";
      publisher = "timonwong";
      version = "0.31.0";
      sha256 = "sha256-aqWJ5gOsraDyZLGayjr8W9vi74n1FAqbmGMUqZQ9lPo=";
    }
    {
      name = "powershell";
      publisher = "ms-vscode";
      version = "2023.3.2";
      sha256 = "sha256-0ueodXRwYnelSwP1MMbgHJFio41kVf656dg6Yro8+hE=";
    }
    {
      name = "vetur";
      publisher = "octref";
      version = "0.37.3";
      sha256 = "sha256-3hi1LOZto5AYaomB9ihkAt4j/mhkCDJ8Jqa16piwHIQ=";
    }
    {
      name = "robotframework-lsp";
      publisher = "robocorp";
      version = "1.10.0";
      sha256 = "sha256-aC+5uAalCi2NwtwCp3q3EDE5x0dRGlTUR1RBoE3K4Zw=";
    }
    {
      name = "gitlab-workflow";
      publisher = "Gitlab";
      version = "3.62.0";
      sha256 = "sha256-JxXBpnW0sRs7ae+fNeryvU6uJyKVbj/CIS8tJWsxDZw=";
    }
    {
      name = "vscode-expo-tools";
      publisher = "Expo";
      version = "1.0.7";
      sha256 = "sha256-ghz8UyMYE+tO22graktz2q4msCDNoGtVbwc93rYxq9A=";
    }
    {
      name = "vscode-sqlite";
      publisher = "alexcvzz";
      version = "0.14.1";
      sha256 = "sha256-jOQkRgBkUwJupD+cRo/KRahFRs82X3K49DySw6GlU8U=";
    }
  ];
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
vscode

