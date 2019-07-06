host:
{ config, lib, pkgs, ... }:

let
  homeManagerThunk = builtins.fromJSON (builtins.readFile /etc/nixos/home-manager.json);
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${./.}/hosts/${host}.nix"
    "${builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${homeManagerThunk.rev}.tar.gz";
      sha256 = homeManagerThunk.sha256;
    }}/nixos"
  ];

  system.stateVersion = "19.09";
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.shellAliases = {
    "update-nix" = "sudo -- sh -c 'nix-prefetch-git https://github.com/aveltras/nix > /etc/nixos/nix.json; nix-prefetch-git https://github.com/rycee/home-manager > /etc/nixos/home-manager.json'";
  };
  
  home-manager.users.romain = import ./home;
  users.users.romain = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
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
    emacs
    firefox
    git
    gotop
    inkscape
    krita
    nix-prefetch-git
    redshift
    rofi
    scrot
    haskellPackages.xmobar
  ];

  fonts.fonts = with pkgs; [
    fantasque-sans-mono
    iosevka-bin
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 1"; } # Lower brightness
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 1"; } # Increase brightness
    ];
  };
  
  services.xserver = {
    desktopManager.xterm.enable = false;
    enable = true;
    layout = "fr";
    xkbOptions = "ctrl:nocaps";
    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    displayManager.lightdm = {
      enable = true;
      background = "${pkgs.nixos-artwork.wallpapers.stripes-logo}/share/artwork/gnome/nix-wallpaper-stripes-logo.png";
      greeters.mini = {
        enable = true;
        user = "romain";
        extraConfig = ''
          [greeter]
          show-password-label = false
          [greeter-theme]
          text-color = "#F5F6F7"
          error-color = "#FF9A8F"
          window-color = "#2A6D95"
          border-color = "#50A2AF"
          password-color = "#F5F6F7"
          password-background-color = "#1E4E6A"
        '';
      };
    };
  };
}
