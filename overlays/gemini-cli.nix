self: super:

let
  pname   = "gemini-cli";
  version = "0.1.1";

  src = super.fetchFromGitHub {
    owner  = "google-gemini";
    repo   = "gemini-cli";
    rev    = "21cfe9f6801f286dda6d51d2886e27bd67bd5fa4";
    sha256 = "Dlh1B1+rGVwA+JjLLjNppa/4Ms7FXMHQW3SY9JIRlcs=";
  };
in
{
  # pop it into nodePackages so you can refer to `pkgs.nodePackages.gemini-cli`
  nodePackages.gemini-cli = super.buildNpmPackage rec {
    inherit pname version src;

    # lock all of its npm deps
    npmDepsHash = "sha256-2zyMrVykKtN+1ePQko9MVhm79p7Xbo9q0+r/P22buQA=";

    fixupPhase = ''
      runHook preFixup
      # Remove broken symlinks
      find $out -type l -exec test ! -e {} \; -delete 2>/dev/null || true
      # Hook up the bundled JS
      mkdir -p $out/bin
      ln -sf \
        "$out/lib/node_modules/@google/gemini-cli/bundle/gemini.js" \
        "$out/bin/gemini"
      # Fix shebangs in both .js and .sh scripts
      patchShebangs "$out/bin" \
                    "$out/lib/node_modules/@google/gemini-cli/bundle/"
      runHook postFixup
    '';

    # enable `nix run .#gemini-cli.updateScript`
    passthru = {
      updateScript = super.nix-update-script { inherit pname version; };
    };

    meta = with super.lib; {
      description = "AI agent that brings the power of Gemini directly into your terminal";
      homepage    = "https://github.com/google-gemini/gemini-cli";
      license     = licenses.asl20;
      maintainers = with maintainers; [ donteatoreo ];
      platforms   = platforms.all;
      mainProgram = "gemini";
    };
  };
}

