{ lib, gccStdenv, vscode-utils, autoPatchelfHook, bash, file, makeWrapper, dotnet-sdk_3
, curl, gcc, icu, libkrb5, libsecret, libunwind, libX11, lttng-ust, openssl, utillinux, zlib
, stdenv
}:

let

  libs = [
    # .NET Core
    openssl
    libkrb5
    zlib
    icu

    # Credential Storage
    libsecret

    # NodeJS
    libX11

    # https://github.com/flathub/com.visualstudio.code.oss/issues/11#issuecomment-392709170
    libunwind
    lttng-ust
    curl

    # General
    gcc.cc.lib
    utillinux # libuuid
  ];

  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {

    mktplcRef = {
      name = "vsliveshare";
      publisher = "ms-vsliveshare";
      version = "1.0.2427";
      sha256 = "0nin085zw3f5swwd9bznvxg4i7gkbpgv6pjbhsf5iy2k5plc0bk9";	
    };

    buildInputs =  libs ++ [ autoPatchelfHook bash file makeWrapper ];

    postPatch = ''
      sed -i \
      -e 's/updateExecutablePermissionsAsync() {/& return;/' \
      -e 's/isInstallCorrupt(traceSource, manifest) {/& return false;/' \
      out/prod/extension-prod.js
    '';


    postInstall = ''
      cp $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/exes/linux-x64/* $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/
      find $out -type f ! -executable -exec file {} + | grep -w ELF | cut -d ':' -f1 | xargs -rd'\n' chmod +x
      find $out -type f -name '*.sh' ! -executable -exec chmod +x {} +
      touch $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/install-linux.Lock
      touch $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/externalDeps-linux.Lock
      touch $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/vsls-agent.lock
      chmod 777 $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/vsls-agent.lock
    '';

    rpath = libs;

    postFixup = ''
      # We cannot use `wrapProgram`, because it will generate a relative path,
      # which will break when copying over the files.
     mv $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/vsls-agent{,-wrapped}
     makeWrapper $out/share/vscode/extensions/ms-vsliveshare.vsliveshare/dotnet_modules/vsls-agent{-wrapped,} \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --set DOTNET_ROOT ${dotnet-sdk_3}
   '';

    meta = with stdenv.lib; {
      description = ''
      '';
    };
  }
