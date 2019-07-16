{ config, lib, pkgs, ... }:

{
  networking.hostName = "clevo";

  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ./../system.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

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
