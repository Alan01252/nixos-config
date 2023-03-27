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
      version = "2021.9.1246542782";
      sha256 = "105vj20749bck6ijdlf7hsg5nb82bi5pklf80l1s7fn4ajr2yk02";
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
      version = "0.10.1";
      sha256 = "0m89sx1qqdkwa9pfmd9b11lp8z0dqpi6jn27js5q4ymscyg41bqd";
    }

  ];
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
vscode

