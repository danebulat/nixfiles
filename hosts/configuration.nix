# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  user="dane";
in
{
  imports = [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # -------------------------------------------------- 
  # Bootloader
  # -------------------------------------------------- 

  boot = {
    # Get latest kernel
    kernelPackages = pkgs.linuxPackages_latest; 

    loader = {
      timeout = 10;

      efi = {
        canTouchEfiVariables = true;

        # Not set to prevent boot loader error
        # Run nixos-install to update bootloader settings
        #efiSysMountPoint = "/boot/eft";
      };
      grub = {
        enable = true;
        version = 2;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        
        # Show up to 20 generations
        configurationLimit = 20;
      };
    }; 
  };

  # -------------------------------------------------- 
  # Kernel Modules
  # -------------------------------------------------- 

  boot.initrd.availableKernelModules = [ 
    "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" 
    "ehci_pci" "sdhci_pci" "uas"
  ];

  # Enable a normal user to mount /dev/sda1 
  fileSystems."/home/${user}/media/sda1" = {
    device = "/dev/sda1";
    fsType = "auto";
    options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
  };

  # Enable a normal user to mount /dev/sda2 
  fileSystems."/home/${user}/media/sdb1" = {
    device = "/dev/sdb1";
    fsType = "auto";
    options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
  };

  # -------------------------------------------------- 
  # Networking
  # -------------------------------------------------- 

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT    = "en_GB.UTF-8";
    LC_MONETARY       = "en_GB.UTF-8";
    LC_NAME           = "en_GB.UTF-8";
    LC_NUMERIC        = "en_GB.UTF-8";
    LC_PAPER          = "en_GB.UTF-8";
    LC_TELEPHONE      = "en_GB.UTF-8";
    LC_TIME           = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable LightDM.
  services.xserver.displayManager.lightdm.enable = true;

  # Enable the XFCE Desktop Environment.
  # services.xserver.desktopManager.xfce.enable = true;

  # Enable the Xmonad window manager.
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  # "xfce+bspwm";
  # "none+bspwm";
  services.xserver.displayManager.defaultSession = "none+xmonad";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user}= {
    isNormalUser = true;
    description = "dane";
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "backlighters" ];
    packages = with pkgs; [

      # Packages not available in Home Manager 
      # can be added here
      discord

      # Global Haskell 
      # cabal-install
      # haskell.compiler.ghc925
      # (haskell-language-server.override { 
      #  supportedGhcVersions = [ "925" ];
      # })
    ];
    # initialPassword = "password";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = { 

    # System environment variables
    variables = {
      TERMINAL = "alacritty";
      EDITOR   = "nvim";
      VISUAL   = "nvim";
    };

    # Packages installed in system profile
    systemPackages = with pkgs; [
      gcc 
      git
      neovim 
      killall
      usbutils
      pciutils
      wget
      xterm
    ];
  }; 

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url    = "https://discord.com/api/download?platform=linux&format=tar.gz";
	  sha256 = "04r1yx6aqd4f4lq7wfcgs3jfpn40gz7gwajzai1aqz12ny78rs7z";
	}; }
      );
    })
  ];

  # Not needed with flakes
  #system.autoUpgrade = {
  #  enable  = true;
  #  channel = "https://nixos.org/channels/nixos-unstable";
  #  dates   = "daily";
  #};

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 14d";
    };
  };

  # --------------------------------------------------
  # Hardware
  # --------------------------------------------------

  # Enable screen brightness control
  hardware.acpilight.enable = true;

  # --------------------------------------------------
  # Fonts
  # --------------------------------------------------

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome     # Icons
    corefonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  # --------------------------------------------------
  # Flakes
  # --------------------------------------------------

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      #keep-outputs          = true
      #keep-derivations      = true
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
