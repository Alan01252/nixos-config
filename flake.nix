{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    ai-assistant = {
      url = "path:/home/alan/Workspace/alan/ai-assistant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yaaf.url = "git+file:///home/alan/Workspace/alan/yaaf?ref=master";
    yaaf-src.url = "path:/home/alan/Workspace/alan/yaaf/nix/modules";
    yaaf-src.flake = false;

    yaaf-go-src.url = "path:/home/alan/Workspace/alan/yaaf/go";
    yaaf-go-src.flake = false;

    stlink.url = "path:/home/alan/Workspace/rugged-networks/stlink";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    codex-cli-nix,
    claude-desktop,
    ai-assistant,
    yaaf,
    yaaf-src,
    yaaf-go-src,
    stlink,
  }:
  let
    system = "x86_64-linux";

    unstableOverlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
          "dotnet-runtime-6.0.36"
        ];
        overlays = [ ];
      };
    };

    claudeOverlay = final: prev: {
      claudeDesktopFhs = claude-desktop.packages.${system}.claude-desktop-with-fhs;
    };

    codexPackageFor = pkgs:
      pkgs.stdenv.mkDerivation rec {
        pname = "codex";
        version = "0.122.0-alpha.10";

        src = pkgs.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-gnu.tar.gz";
          sha256 = "1pmpnvcc1ywfdflbhzyypl5lk1wqs5r5yqg65wkdwxbc88qxr08l";
        };

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
        ];

        buildInputs = [
          pkgs.stdenv.cc.cc.lib
          pkgs.libcap
          pkgs.openssl
          pkgs.zlib
        ];

        unpackPhase = ''
          tar -xzf "$src"
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/bin"

          codex_bin="$(find . -type f -name codex -perm -0100 | head -n1)"
          if [ -z "$codex_bin" ]; then
            codex_bin="$(find . -type f -perm -0100 | head -n1)"
          fi

          if [ -z "$codex_bin" ]; then
            echo "Could not find codex binary in release tarball" >&2
            exit 1
          fi

          cp "$codex_bin" "$out/bin/codex-raw"
          chmod +x "$out/bin/codex-raw"

          makeWrapper "$out/bin/codex-raw" "$out/bin/codex" \
            --set DISABLE_AUTOUPDATER 1 \
            --set CODEX_EXECUTABLE_PATH "$out/bin/codex-raw"

          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "OpenAI Codex CLI";
          homepage = "https://github.com/openai/codex";
          mainProgram = "codex";
          platforms = platforms.linux;
        };
      };

    codexOverlay = final: prev: {
      codex = codexPackageFor final;
    };

    openvpnOverlay = final: prev: {
      openvpn = prev.openvpn.overrideAttrs (oldAttrs: {
        version = "2.6.4";
        buildInputs = oldAttrs.buildInputs ++ [
          prev.libnl
          prev.libcap_ng
          prev.lz4
        ];
        src = prev.fetchurl {
          url = "https://swupdate.openvpn.org/community/releases/openvpn-2.6.4.tar.gz";
          sha256 = "NxoqMjqZp5KZubTKpKMbx7LN/2MjbmjUKfPuUOdfPdQ=";
        };
      });
    };

    sagaclawPackageFor = pkgs:
      (pkgs.buildGoModule.override { go = pkgs.go_1_25; }) {
        pname = "sagaclaw";
        version = "0.1.0";

        src = pkgs.runCommandLocal "yaaf-sagaclaw-src" { } ''
          mkdir -p "$out"
          cp -R ${inputs.yaaf-go-src} "$out/go"
          chmod -R u+w "$out/go"
        '';

        modRoot = "go/apps/sagaclaw";
        subPackages = [ "./cmd/sagaclaw" ];
        vendorHash = "sha256-dkbDK6D7jHY4QvGJnHDS9vNRBMrgWzqOmMvVaGGU91g=";
        env.GOWORK = "off";

        postInstall = ''
          mkdir -p "$out/share/sagaclaw"
          cp "$src/go/apps/sagaclaw/SOUL.md" "$out/share/sagaclaw/SOUL.md"
        '';

        meta = with pkgs.lib; {
          description = "SagaClaw agent service";
          mainProgram = "sagaclaw";
          platforms = platforms.linux;
        };
      };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
        inherit yaaf;
      };

      modules = [
        ({
          nixpkgs = {
            overlays = [
              unstableOverlay
              openvpnOverlay
              claudeOverlay
              codexOverlay
            ];

            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "dotnet-sdk-6.0.428"
              "dotnet-runtime-6.0.36"
            ];
          };
        })

        "${inputs.yaaf-src}/sagaclaw.nix"
        "${inputs.yaaf-src}/sagaclaw-container.nix"

        ({ lib, ... }: {
          boot.enableContainers = true;

          containers.sagaclaw.bindMounts."/root/.codex" = {
            hostPath = "/home/alan/.codex";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/root/.local/bin" = {
            hostPath = "/home/alan/.local/bin";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/home/alan/.codex" = {
            hostPath = "/home/alan/.codex";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/home/alan/.local/bin" = {
            hostPath = "/home/alan/.local/bin";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/var/lib/sagaclaw/workspace-providers" = {
            hostPath = "/var/lib/sagaclaw/workspace-providers";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/home/alan/Workspace/saga-claw/RuggedNetworks" = {
            hostPath = "/home/alan/Workspace/saga-claw/RuggedNetworks";
            isReadOnly = false;
          };

          containers.sagaclaw.bindMounts."/home/alan/Workspace/rugged-networks/ifu-bastion-proxy" = {
            hostPath = "/home/alan/Workspace/rugged-networks/ifu-bastion-proxy";
            isReadOnly = false;
          };

          sagaclawContainer = {
            enable = true;
            workspacePath = "/home/alan/Workspace/alan/yaaf";
            pluginsDir = "/var/lib/sagaclaw/plugins";
            model = "gpt-5.4-mini";
          };

          containers.sagaclaw.privateNetwork = lib.mkForce false;

          containers.sagaclaw.config = { pkgs, lib, ... }:
            let
              sagaclawPackage = sagaclawPackageFor pkgs;

              sagaclawTools = [
                pkgs.awscli2
                pkgs.bashInteractive
                pkgs.bubblewrap
                pkgs.findutils
                pkgs.python3
                pkgs.coreutils
                pkgs.git
                pkgs.gawk
                pkgs.gnugrep
                pkgs.gnused
                pkgs.jq
                pkgs.openssh
                pkgs.perl
                pkgs.ripgrep
                pkgs.ssm-session-manager-plugin
                sagaclawPackage
                pkgs.step-cli
                pkgs.codex
              ];

              sagaclawServicePath = [
                pkgs.awscli2
                pkgs.bashInteractive
                pkgs.coreutils
                pkgs.findutils
                pkgs.python3
                pkgs.git
                pkgs.gawk
                pkgs.gnugrep
                pkgs.gnused
                pkgs.jq
                pkgs.openssh
                pkgs.perl
                pkgs.ripgrep
                pkgs.ssm-session-manager-plugin
                pkgs.step-cli
                pkgs.codex
              ];
            in
            {
              environment.systemPackages = lib.mkForce sagaclawTools;

              systemd.tmpfiles.rules = [
                "L+ /usr/bin/bwrap - - - - /run/current-system/sw/bin/bwrap"
                "d /var/lib/sagaclaw/workspace-providers 0755 alan users - -"
                "d /var/lib/sagaclaw/aws 0700 alan users - -"
                "d /var/lib/sagaclaw/aws/cli 0700 alan users - -"
                "d /var/lib/sagaclaw/aws/cli/cache 0700 alan users - -"
                "d /var/lib/sagaclaw/aws/sso 0700 alan users - -"
                "d /var/lib/sagaclaw/aws/sso/cache 0700 alan users - -"
                "f /var/lib/sagaclaw/aws/credentials 0600 alan users - -"
                "d /var/lib/sagaclaw/step 0700 alan users - -"
                "d /var/lib/sagaclaw/ssh 0700 alan users - -"
                "d /var/lib/sagaclaw/codex 0700 alan users - -"
                "d /var/lib/sagaclaw/codex/rules 0700 alan users - -"
                "d /home/alan/Workspace/rugged-networks 0755 alan users - -"
                "d /home/alan/Workspace/rugged-networks/ifu-bastion-proxy 0755 alan users - -"
                "d /home/alan/Workspace/saga-claw/RuggedNetworks 0755 alan users - -"
                "L+ /home/alan/.aws - - - - /var/lib/sagaclaw/aws"
                "L+ /home/alan/.step - - - - /var/lib/sagaclaw/step"
                "L+ /home/alan/.ssh - - - - /var/lib/sagaclaw/ssh"
              ];

              systemd.services.sagaclaw.path = lib.mkForce sagaclawServicePath;

              systemd.services.sagaclaw.preStart = lib.mkAfter ''
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/aws
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/aws/cli
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/aws/cli/cache
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/aws/sso
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/aws/sso/cache
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/step
                install -d -m 0700 -o alan -g users /var/lib/sagaclaw/ssh
                touch /var/lib/sagaclaw/aws/credentials
                chown alan:users /var/lib/sagaclaw/aws/credentials
                chmod 0600 /var/lib/sagaclaw/aws/credentials

                cat > /var/lib/sagaclaw/aws/config <<'EOF'
                [sso-session rugged]
                sso_start_url = https://ruggednetworks.awsapps.com/start
                sso_region = eu-west-1
                sso_registration_scopes = sso:account:access

                [profile onvp-staging]
                sso_session = rugged
                sso_account_id = 882131928231
                sso_role_name = Allow-IFU-Bastion-ECS-Exec
                region = eu-west-1
                output = json

                [profile onvp-prod]
                sso_session = rugged
                sso_account_id = 542428796143
                sso_role_name = Allow-IFU-Bastion-ECS-Exec
                region = eu-west-1
                output = json
                EOF

                chown alan:users /var/lib/sagaclaw/aws/config
                chmod 0600 /var/lib/sagaclaw/aws/config

                if [ ! -f /var/lib/sagaclaw/step/profiles/staging/config/defaults.json ]; then
                  HOME=/home/alan STEPPATH=/var/lib/sagaclaw/step step ca bootstrap \
                    --ca-url https://ssh-auth-ca.staging-onvp.click \
                    --fingerprint 20fc0e800f1794ce10d2b82f7c1ec7c461f9d5753e80b140862950f24e228b41 \
                    --context staging
                fi

                if [ ! -f /var/lib/sagaclaw/step/profiles/production/config/defaults.json ]; then
                  HOME=/home/alan STEPPATH=/var/lib/sagaclaw/step step ca bootstrap \
                    --ca-url https://ssh-auth-ca.onvp.io \
                    --fingerprint 26d454d78b5b0cc89911e18bc3131e81e4826f35e5456e164cfa5a77038a62ee \
                    --context production
                fi
              '';

              users.users.alan = {
                isNormalUser = true;
                uid = 1000;
                group = "users";
                home = "/home/alan";
                createHome = true;
                shell = pkgs.bashInteractive;
              };

              services.sagaclaw.user = "alan";
              services.sagaclaw.group = "users";
              services.sagaclaw.package = sagaclawPackage;

              services.sagaclaw.extraEnvironment = {
                AWS_CONFIG_FILE = "/var/lib/sagaclaw/aws/config";
                AWS_DEFAULT_REGION = "eu-west-1";
                AWS_SHARED_CREDENTIALS_FILE = "/var/lib/sagaclaw/aws/credentials";
                HOME = "/home/alan";
                CODEX_HOME = "/home/alan/.codex";
                SAGACLAW_WORKSPACE_PROVIDER_DIR = "/var/lib/sagaclaw/workspace-providers";
                STEPPATH = "/var/lib/sagaclaw/step";
                STEP_AUTH_MODE = "console";
              };

              services.sagaclaw.extraReadWritePaths = [
                "/home/alan/Workspace/saga-claw/RuggedNetworks"
                "/home/alan/.codex"
              ];

              services.sagaclaw.slack.allowedUserIds = [ "U04U21A8Q66" ];
            };
        })

        ./configuration.nix
      ];
    };
  };
}
