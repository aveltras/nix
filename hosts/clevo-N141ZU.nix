{ config, lib, pkgs, ... }:

{
  networking.hostName = "clevo";
  
  # Enable touchpad support
  services.xserver.libinput.enable = true;

  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  hardware.cpu.intel.updateMicrocode = true;
  services.fstrim.enable = true;
  
  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };
}
