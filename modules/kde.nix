{ config, pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = false;
  security.pam.services.login.kwallet.enable = lib.mkForce false;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # PIM / Akonadi stack
    akregator
    kmail
    korganizer
    kontact
    kaddressbook
    kdepim-addons
    kdepim-runtime
    akonadi
    akonadi-calendar
    akonadi-contacts
    akonadi-mime
    akonadi-search
    kwalletmanager

    # Utilities
    ark
    gwenview
    okular
    kate
    kcharselect
    kfind
    kruler
    kcolorchooser
    kolourpaint
    kgpg
    ktimer
    kmouth
    kmag
    kontrast
    khelpcenter
    konsole

    # Multimedia
    dragon
    juk
    kamoso
    elisa
    kwave

    # Network apps
    konqueror
    kget
    krdc
    krfb

    # Games
    bomber
    bovo
    granatier
    kapman
    katomic
    kblackbox
    kblocks
    kbounce
    kbreakout
    kdiamond
    kfourinline
    kgoldrunner
    kigo
    killbots
    kjumpingcube
    klickety
    klines
    kmahjongg
    kmines
    knavalbattle
    knetwalk
    knights
    kolf
    kollision
    konquest
    kpat
    kreversi
    ksirk
    ksnakeduel
    ksquares
    ksudoku
    ktuberling
    kubrick
    lskat
    palapeli
    picmi

    # Misc
    plasma-browser-integration
    plasma-systemmonitor
    kgamma
    oxygen
    baloo
    print-manager
    skanlite
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  # Disable Baloo file indexer

  environment.systemPackages = with pkgs; [
    rustdesk
    vivaldi
    vivaldi-ffmpeg-codecs
    kitty
    kdePackages.krohnkite
    kdePackages.spectacle
    kdePackages.kcalc
    libreoffice-qt6-fresh
  ];
}

