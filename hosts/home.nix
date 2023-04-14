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
    google-chrome
    htop
    httpie
    jq
    libreoffice
    pcmanfm
    tree
  ];

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

  xsession = {
    enable = true;
    numlock.enable = true;
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

  #home.file = {
  #  ".config/alacritty/alacritty.yml".text = ''
  #    {"font": {"bold":{"style":"Bold"}}}
  #  '';
  #};

  # --------------------------------------------------
  # Services 
  # --------------------------------------------------

  services.dunst = {
    enable = true;
  };
}
