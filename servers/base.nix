{ config, pkgs, lib, ... }:

let sources = import ../nix/sources.nix;

in {
	imports = [
		<acm-aws/packages/imports.nix>
		<acm-aws/nix/modules>
	];

	services.journald = {
		enableHttpGateway = false;
		extraConfig = ''
			Compress=true
			SystemMaxUse=50M
			SystemMaxFileSize=1M
			RuntimeMaxUse=1M
			MaxRetentionSec=6month
		'';
	};

	nix.settings = {
		auto-optimise-store = true;
		experimental-features = [ "nix-command" "flakes" ];
	};

	documentation.enable = false;
	documentation.nixos.enable = false;

	programs.command-not-found.enable = false;

	xdg.autostart.enable = false;
	xdg.icons.enable = false;
	xdg.mime.enable = false;
	xdg.sounds.enable = false;

	environment.systemPackages = with pkgs; [
		htop
		wget
		git
	];

	# Deploy ./static to all servers.
	deployment.staticPaths = [ ../static ];
}
