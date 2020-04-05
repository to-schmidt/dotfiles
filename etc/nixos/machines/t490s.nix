# configuration for Lenovo ThinkPad T490s

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # make /tmp tmpfs and clean it on every startup
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # bootup splash screen
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  # kernel settings (extracted form hardware-configuration)
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  boot.kernel.sysctl."kernel.kptr_restrict" = pkgs.lib.mkOverride 10 0;
  boot.kernel.sysctl."kernel.perf_event_paranoid" = pkgs.lib.mkOverride 10 1;

  # number of cores used by nix
  nix.maxJobs = lib.mkDefault 8;

  # network hostname
  networking.hostName = "T490s";

  # tlp battery management services
  # tlp-stats prints current state
  services.tlp.enable = true;

  # what todo when lid is closed
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchDocked = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";

  # powerManagement
  powerManagement.enable = true;
  # available cpu frequency governors: "ondemand", "powersave", "performance"
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # touchpad
  services.xserver.libinput.enable = true;

  # bluetooth
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
