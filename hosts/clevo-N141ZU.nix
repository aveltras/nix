{ config, lib, pkgs, ... }:

{
  # Enable touchpad support
  services.xserver.libinput.enable = true;
}
