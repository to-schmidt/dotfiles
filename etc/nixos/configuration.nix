{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./current-machine.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nix.trustedBinaryCaches = [
    "http://hydra.nixos.org"
    "http://hydra.cryp.to"
  ];

  nix.useSandbox = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # packages to install
  environment.systemPackages = with pkgs; [
    wget
    killall
    file
    htop
    gotop
    powertop
    lshw
    neofetch
    lxrandr

    gnome3.file-roller
    gnome3.nautilus
    vim
    atom
    zsh
    terminator

    thunderbird
    chromium
    discord
    spotify

    libreoffice
    texlive.combined.scheme-full
    zathura
    pdfpc

    gnupg
    openssl
    keepassxc

    git
    git-quick-stats
    cloc
    stow
    zip
    unzip
    docker-compose
    sshfs-fuse

    feh
    xcompmgr
    lxappearance-gtk3
    gtk-engine-murrine
    arc-icon-theme
    arc-theme
    alsaUtils

    rofi
    polybar
    haskellPackages.ghc
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    alock
    acpi
  ];

  fonts.fonts = with pkgs; [
    siji
    noto-fonts
    material-icons
    font-awesome
  ];

  # utility programs
  programs.bash.enableCompletion = true;
  programs.ssh.startAgent = false;
  programs.zsh.enable = true;
  programs.light.enable = true;

  # dbus services for battery and storage
  services.upower.enable = true;
  services.udisks2.enable = true;

  # xserver
  services.xserver.enable = true;

  # keyboard layout
  services.xserver.layout = "de";
  services.xserver.xkbVariant = "neo";
  console.keyMap = "neo";

  # displayManager (lightdm login screen)
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
    ${pkgs.xcompmgr}/bin/xcompmgr -ncfF -I.025 -O.05 -D10 &
  '';

  # windowManager (xmonad+none)
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  # autorandr
  services.autorandr.enable = true;
  services.autorandr.defaultTarget = "STANDALONE";

  # networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  services.tor.enable = true;
  services.tor.client.enable = true;
  services.tor.controlPort = 9051;
  services.privoxy.enable = true;
  networking.proxy.default = "";

  # services needed for file-manager
  services.gvfs.enable = true;
  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
  services.devmon.enable = true; # automatic device mounting daemon

  # key management
  services.gnome3.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # virtualisation
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.groups.tobias = {};
  users.users.tobias = {
    isNormalUser = true;
    createHome = true;
    home = "/home/tobias";
    group = "tobias";
    extraGroups = ["wheel" "networkManager" "video" "docker" "virtualbox"];
  };

  system.stateVersion = "20.03";
}
