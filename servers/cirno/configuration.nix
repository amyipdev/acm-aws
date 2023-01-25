{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/virtualisation/amazon-image.nix")
		../base.nix
	];

	services.diamondburned.caddy = {
		enable = true;
		configFile = ./secrets/Caddyfile;
		environment = import ./secrets/caddy-env.nix;
	};

	services.dischord = {
		enable = true;
		config = builtins.readFile ./secrets/dischord-config.toml;
	};

	systemd.services.acmregister = {
		enable = true;
		description = "ACM member registration Discord bot";
		after = [ "network-online.target" ];
		wantedBy = [ "multi-user.target" ];
		environment = import ./secrets/acmregister-env.nix;
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.acmregister}/bin/acmregister";
		};
	};

	systemd.services.acm-nixie = {
		enable = true;
		description = "acmCSUF's version of the nixie bot.";
		after = [ "network-online.target" ];
		wantedBy = [ "multi-user.target" ];
		environment = import ./secrets/acm-nixie-env.nix;
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.acm-nixie}/bin/acm-nixie";
			DynamicUser = true;
			StateDirectory = "acm-nixie";
			ReadWritePaths = [ "/var/lib/acm-nixie" ];
		};
	};

	systemd.services.crying-counter = {
		enable = true;
		description = "Crying counter Discord bot";
		after = [ "network-online.target" ];
		wantedBy = [ "multi-user.target" ];
		environment = import ./secrets/crying-counter-env.nix;
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.crying-counter}/bin/crying-counter";
			DynamicUser = true;
		};
	};

	environment.systemPackages = with pkgs; [
		ncdu
	];
}
