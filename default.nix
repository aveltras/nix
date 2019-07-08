host:
{ config, lib, pkgs, ... }:

let
  homeManagerThunk = builtins.fromJSON (builtins.readFile /etc/nixos/home-manager.json);
  waylandOverlay = (import (builtins.fetchTarball "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz"));
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/cachix.nix
    "${./.}/hosts/${host}.nix"
    "${builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${homeManagerThunk.rev}.tar.gz";
      sha256 = homeManagerThunk.sha256;
    }}/nixos"
  ];

  system.stateVersion = "19.09";

  nixpkgs.overlays = [ waylandOverlay ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
    	exec sway
    fi
  '';
  environment.shellAliases = {
    "update-nix" = "sudo -- sh -c 'nix-prefetch-git https://github.com/aveltras/nix > /etc/nixos/nix.json; nix-prefetch-git https://github.com/rycee/home-manager > /etc/nixos/home-manager.json'";
  };

  home-manager.users.romain = import ./home;
  users.users.romain = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };
  
  networking.networkmanager = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/61490
    extraConfig = ''
      [main]
      rc-manager=resolvconf
    '';
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" ];
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    alacritty
    bemenu
    cachix
    firefox
    git
    gotop
    inkscape
    j4-dmenu-desktop
    krita
    nix-prefetch-git
    pavucontrol
  ];

  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      iosevka-bin
    ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.udisks2.enable = true;

  services.emacs = {
    enable = true;
    package = (pkgs.emacs.overrideAttrs (attrs: {
      postInstall = (attrs.postInstall or "") + ''
        rm $out/share/applications/emacs.desktop
      '';
    }));
  };
  
  programs.zsh.enable = true;
  programs.light.enable = true;
  # services.actkbd = {
  #   enable = true;
  #   bindings = [
  #     # { keys = [ 113 ]; events = [ "key" ]; command = "pactl set-sink-volume 0 toggle"; } # Toggle sound
  #     # { keys = [ 114 ]; events = [ "key" "rep" ]; command = "pactl set-sink-volume 0 -1%"; } # Lower volume
  #     # { keys = [ 115 ]; events = [ "key" "rep" ]; command = "pactl set-sink-volume 0 +1%"; } # Increase volume
  #     { keys = [ 224 ]; events = [ "key" ]; command = "light -U 1"; } # Lower brightness
  #     { keys = [ 225 ]; events = [ "key" ]; command = "light -A 1"; } # Increase brightness
  #   ];
  # };

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wayland;
    latitude = "45.75";
    longitude  = "4.85";
    temperature = {
      day = 5000;
      night = 3250;
    };
  };
  
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      grim
      redshift-wayland
      slurp
      swaybg
      swayidle
      swaylock
      waybar
      xwayland
    ];
  };

  services.xserver.enable = false;
  
  # services.xserver = {
  #   # desktopManager.xterm.enable = false;
  #   enable = true;
  #   layout = "fr";
  #   xkbOptions = "ctrl:nocaps";
  #   # windowManager.default = "xmonad";
  #   # windowManager.xmonad = {
  #   #   enable = true;
  #   #   enableContribAndExtras = true;
  #   # };
  #   displayManager.lightdm = {
  #     enable = true;
  #     background = "${pkgs.nixos-artwork.wallpapers.stripes-logo}/share/artwork/gnome/nix-wallpaper-stripes-logo.png";
  #     greeters.mini = {
  #       enable = true;
  #       user = "romain";
  #       extraConfig = ''
  #         [greeter]
  #         show-password-label = false
  #         [greeter-theme]
  #         text-color = "#F5F6F7"
  #         error-color = "#FF9A8F"
  #         window-color = "#2A6D95"
  #         border-color = "#50A2AF"
  #         password-color = "#F5F6F7"
  #         password-background-color = "#1E4E6A"
  #       '';
  #     };
  #   };
  # };
}
