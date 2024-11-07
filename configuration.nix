{ config, lib, pkgs, ... }:
{
	imports = [
		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "penetration";
	networking.networkmanager.enable = true;

	time.timeZone = "Asia/Nicosia";

	users.users.mh3th = {
		isNormalUser = true;
		home = "/home/mh3th";
		extraGroups = [ "wheel" "networkmanager" ];
		shell = pkgs.fish;
	};

	environment.systemPackages = with pkgs; [
		pkgs.git
		pkgs.kitty
		pkgs.htop
		pkgs.firefox
		pkgs.home-manager
		pkgs.fastfetch
		pkgs.fasd
		pkgs.pavucontrol
		pkgs.rofi-wayland
		pkgs.ripgrep
		pkgs.bat
		pkgs.broot
                pkgs.fd
                pkgs.gcc
                pkgs.cargo
                pkgs.rustc
                pkgs.pnpm
                pkgs.nodejs
	];


	system.stateVersion = "24.05";

	hardware.opengl.enable = true;
	#hardware.bluetooth.enable = true;
	#hardware.bluetooth.powerOnBoot = true;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	services.xserver = {
		videoDrivers = ["nvidia"];
	};
	hardware.nvidia = {
		modesetting.enable = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.production;
		prime = {
			offload = {
				enable = true;
				enableOffloadCmd = true;
			};
			intelBusId = "PCI:0:2:0";
			nvidiaBusId = "PCI:1:0:0";

		};
		powerManagement.finegrained = true;

	};
	nixpkgs.config.allowUnfree = true;
	programs.hyprland.enable = true;
	programs.fish.enable = true;
	programs.waybar.enable = true;

	fonts.packages = with pkgs; [
		jetbrains-mono
		noto-fonts
		noto-fonts-emoji
		twemoji-color-font
		font-awesome
		powerline-fonts
		powerline-symbols
		(nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
		dejavu_fonts
		noto-fonts-cjk
	];
	nix = {
		package = pkgs.nixFlakes;
		settings.experimental-features = [ "nix-command" "flakes" ];
	};
}





