{ config, pkgs, ... }:

let 
  user="dane";
in
{
  home.stateVersion  = "22.11";
  home.username      = "${user}";
  home.homeDirectory = "/home/${user}";
  
  # --------------------------------------------------
  # Packages
  # --------------------------------------------------

  home.packages = with pkgs; [

    # File Management
    unzip
    unrar

    # Video/Audio
    feh
    mpv
    pavucontrol
    vlc

    # Apps
    blueman
    du-dust
    flameshot
    galculator
    google-chrome
    hexchat
    htop
    httpie
    jq
    libreoffice
    nomacs
    pcmanfm
    tree

    # System tray + Desktop
    cbatticon
    nitrogen
    stalonetray
    volumeicon
    xfce.xfce4-power-manager
    xfce.xfce4-notifyd
  ];

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

  xsession = {
    enable = true;
    numlock.enable = true;

    # Start xmonad
    # windowManager.command = "${pkgs.xmonad-with-packages}/bin/xmonad";

    # Extra commands to run during initialisation
    initExtra = ''
      # Set screen resolution
      xrandr --output Virtual1 --mode 1440x900

      # Set background image with feh
      feh --bg-scale ~/Pictures/Wallpapers/nix-wallpaper-gear.png &

      # Set up stalonetray 
      stalonetray &
      volumeicon &
      cbatticon &
      nm-applet &

      # Start xmobar 
      xmobar ~/.config/xmobar/xmobarrc &
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git.protocol = "https";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = import ../modules/alacritty.nix;
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    extraConfig = ''
      # Vim style pane switching
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
    historyLimit = 2000;
    # Prefer vi over emacs
    keyMode = "vi";
    # Enable mouse support
    mouse = true;
    # Automatically spawn a session if trying to 
    # attach and none are running
    newSession = true;
    # Set TERM variable to avoid wrong backspace behavior
    terminal = "xterm-256color";
    # Set prefix key
    prefix = "C-x";
  };

  # --------------------------------------------------
  # Neovim
  # --------------------------------------------------

  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    withNodeJs    = true;
  };

  home.file.".config/nvim/init.lua" = {
    source = ../dotfiles/neovim/init.lua;
  };

  home.file.".config/nvim/coc-settings.json" = {
    source = ../dotfiles/neovim/coc-settings.json;
  };

  home.file.".config/nvim/opt/tree-sitter-haskell".source = pkgs.fetchFromGitHub {
    owner  = "tree-sitter";
    repo   = "tree-sitter-haskell";
    rev    = "98fc7f5";
    sha256 = "BDvzmFIGABtkWEUbi74o3vPLsiwNWsQDNura867vYpU=";
  };

  # --------------------------------------------------
  # Xmonad 
  # --------------------------------------------------

  programs.xmobar.enable = true;

  # xmonad config
  home.file.".config/xmonad/xmonad.hs" = {
    source = ../dotfiles/xmonad/xmonad.hs;
  };

  # xmobar config
  home.file.".config/xmobar/xmobarrc" = {
    source = ../dotfiles/xmobar/xmobarrc;
  };

  # stalonetray config 
  home.file.".stalonetrayrc" = {
    source = ../dotfiles/stalonetray/stalonetrayrc;
  };

  # Copy wallpaper to ~/Pictures/Wallpapers
  home.file."Pictures/Wallpapers/nix-wallpaper-gear.png" = {
    source = ../wallpapers/nix-wallpaper-gear.png;
  };

  # --------------------------------------------------
  # Dotfiles
  # --------------------------------------------------

  # Example: Copy whole directory
  # home.file."doom.d" = {
  #   source    = ./doom.d;
  #   recursive = true;
  #   onChange  = builtins.readFile ./doom.sh;
  # };
  
  # Example: Copy file
  # home.file.".config/polybar/script/mic.sh" = {
  #  source = ./mic.sh;
  #  executable = true;
  # };

  # home.file = {
  #   ".config/alacritty/alacritty.yml".text = ''
  #     {"font": {"bold":{"style":"Bold"}}}
  #   '';
  # };

  # --------------------------------------------------
  # Services 
  # --------------------------------------------------

  services.dunst = {
    enable = true;
  };

  services.picom.enable = true;

  # home.file.".config/picom/picom.conf" = {
  #   source = ../dotfiles/picom/picom.conf;
  # };

}
