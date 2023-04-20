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
    brave
    cinnamon.nemo
    du-dust
    firefox
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
    xfce.mousepad

    # Development
    nodejs

    # System tray + Desktop
    cbatticon
    dconf
    dmenu
    networkmanagerapplet  # nm-applet nm-connection-editor
    nitrogen
    stalonetray
    volumeicon
    xfce.xfce4-power-manager
    xfce.xfce4-notifyd

    # Utilities
    bashmount
    lxappearance
    trash-cli
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
      xrandr --output HDMI-2 --mode 1920x1080
      xrandr --output eDP-1 --mode 1920x1080 --right-of HDMI-2

      # Set background image with feh
      feh --bg-scale ~/Pictures/Wallpapers/nix-wallpaper-gear.png &

      # Start stalonetray
      stalonetray &
      volumeicon &
      cbatticon &
      #nm-applet &
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
  # Bash
  # --------------------------------------------------

  programs.bash = {
    enable = true;

    # Extra commands that should be run in ~/.bashrc
    bashrcExtra = ''
    '';

    # Shell aliases
    shellAliases = 
      let sysProfile = "/nix/var/nix/profiles/system";
      in
      {
        nv = "nvim";
        os-switch = "cd ~/nixfiles && sudo nixos-rebuild switch --flake .#dane";
        os-conf = "cd ~/nixfiles";
        os-open-home-conf = "nvim ~/nixfiles/hosts/home.nix";
        os-upgrade = "cd ~/nixfiles && sudo nixos-rebuild switch --flake .#dane --upgrade";
        os-generations = "sudo nix-env --list-generations --profile ${sysProfile}";
        os-generations-keep-15 = "sudo nix-env --profile ${sysProfile} --delete-generations +15";
        os-gc = "nix-collect-garbage";
      };
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

  # Doesn't work, needs to be cloned directly in $HOME/.config/nvim/opt 
  # so filesystem can be written.
  # home.file.".config/nvim/opt/tree-sitter-haskell".source = pkgs.fetchFromGitHub {
  #   owner  = "tree-sitter";
  #   repo   = "tree-sitter-haskell";
  #   rev    = "98fc7f5";
  #   sha256 = "BDvzmFIGABtkWEUbi74o3vPLsiwNWsQDNura867vYpU=";
  # };

  # --------------------------------------------------
  # Xmonad + Xmobar
  # --------------------------------------------------

  programs.xmobar.enable = true;

  programs.xmobar.extraConfig = ''
    Config { overrideRedirect = False
       , font        = "xft:FiraCode Nerd Font-10"
       , bgColor     = "#141414"
       , fgColor     = "#c5c8c6"
       , position    = BottomSize L 95 28 
       , allDesktops = True
       , persistent  = True
       , commands = [ Run Weather "EGPF"
                        [ "--template", "<weather> <tempC>°C"
                        , "-L", "0"
                        , "-H", "25"
                        , "--low"   , "lightblue"
                        , "--normal", "#f8f8f2"
                        , "--high"  , "red"
                        ] 36000
                    , Run Cpu
                        [ "-L", "3"
                        , "-H", "50"
                        , "--high"  , "red"
                        , "--normal", "green"
                        ] 10
                    , Run Alsa "default" "Master"
                        [ "--template", "<volumestatus>"
                        , "--suffix"  , "True"
                        , "--"
                        , "--on", ""
                        ]
                    , Run Memory ["--template", "Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                    , Run XMonadLog
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = " %XMonadLog% }{ %alsa:default:Master% | %cpu% | %memory% * %swap% | %EGPF% | %date% "
       }
    '';

  # xmonad config
  home.file.".config/xmonad/xmonad.hs" = {
    source = ../dotfiles/xmonad/xmonad.hs;
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

  services = {
    dunst = {
      enable = true;
      configFile = ../dotfiles/dunst/dunstrc;
    };

    picom.enable = true;
  };
}
