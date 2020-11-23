{ pkgs, config, ... }:
{
  #nixpkgs.overlays = [(self: super: {
  #  updateScript = pkgs.writeScriptBin "updateScript" ''
  #    #!${pkgs.stdenv.shell}
  #
  #      ${config.system.build.nixos-rebuild}/bin/nixos-rebuild --upgrade
  #    '';
  #  })];

  environment.etc."webhook.conf".text = ''
  [
    {
      "id": "screen_off",
      "execute-command": "/var/run/current-system/sw/bin/xset",
      "pass-environment-to-command": [
	       {
		"source": "string",
		"envname": "XAUTHORITY",
		"name": "/home/alan/.Xauthority"
	      },
              {
		"source": "string",
		"envname": "DISPLAY",
		"name": ":0"
	      }
      ],

      "pass-arguments-to-command": [
	      {
		"source": "string",
		"name": "-display"
	      },
              {
		"source": "string",
		"name": ":0"
	      },
              {
		"source": "string",
		"name": "dpms"
	      },
              {
		"source": "string",
		"name": "force"
	      },
              {
		"source": "string",
		"name": "off"
	      }

      ],
      "command-working-directory": "/tmp"
    },
    {
      "id": "screen_on",
      "execute-command": "/var/run/current-system/sw/bin/xset",
      "pass-environment-to-command": [
	       {
		"source": "string",
		"envname": "XAUTHORITY",
		"name": "/home/alan/.Xauthority"
	      },
              {
		"source": "string",
		"envname": "DISPLAY",
		"name": ":0"
	      }
      ],
      "pass-arguments-to-command": [
             {
		"source": "string",
		"name": "-display"
	      },
              {
		"source": "string",
		"name": ":0"
	      },
              {
		"source": "string",
		"name": "dpms"
	      },
              {
		"source": "string",
		"name": "force"
	      },
              {
		"source": "string",
		"name": "on"
	      }

      ],
      "command-working-directory": "/tmp"
    },
  ]
  '';
  users.users.webhook = {
    isNormalUser = false;
  };

  systemd.services.webhook = {
    enable = true;

    serviceConfig = {
      ExecStart = "${pkgs.webhook}/bin/webhook -hooks /etc/webhook.conf -verbose";
    };
  };
}
