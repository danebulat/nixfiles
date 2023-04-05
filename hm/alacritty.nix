# https://github.com/alacritty/alacritty/blob/master/alacritty.yml
{
  # window settings
  window = {
    # window dimensions
    dimensions = {
      lines = 20;
      columns = 80;
    };

    # window position
    # position = {
    #   x = 0;
    #   y = 0;
    # };

    # window padding
    padding = {
      x = 6;
      y = 6;
    };

    # window decorations
    # full: Borders and title bar 
    # none: Neither borders nor title bar
    decorations = "full";

    # background opacity
    opacity = 1.0;

    # startup mode (windowed, maximized, fullscreen)
    startup_mode = "windowed";

    # allow terminal applications to change Alacritty's window title
    dynamic_title = true;

    # decoration theme variant (Dark, Light, None)
    decoration_theme_variant = "Dark";

    # resize by discrete steps equal to cell dimensions 
    resize_increments = false;
  };

  # scrolling settings
  scrolling = {
    # maximum lines in scrollback buffer
    history = 10000;
    # scrolling distance multiplier
    multiplier = 1;
  };

  # font settings
  font = {
    # normal (roman) font face 
    normal = {
      family = "FiraCode Nerd Font";
      style = "Regular";
    };

    # bold font face
    bold = {
      family = "FiraCode Nerd Font";
      style = "Bold";
    };

    # italic font face
    italic = {
      family = "FiraCode Nerd Font";
      style = "Italic";
    };

    # bold italic font face
    bold_italic = {
      family = "FiraCode Nerd Font";
      style = "Bold Italic";
    };

    # point size
    size = 13.0;
  };

  # color settings (Tomorrow Night)
  colors = {
    # default colors
    primary = {
      background = "#1d1f21";
      foreground = "#c5c8c6";

      dim_foreground = "#828482";
      bright_foreground = "#eaeaea";
    };

    # cursor colors
    cursor = {
      text = "CellBackground";
      cursor = "CellForeground";
    };

    # vi mode cursor colors
    vi_mode_cursor = {
      text = "CellBackground";
      cursor = "CellForeground";
    };

    # search colors
    search = {
      matches = {
        foreground = "#000000";
        background = "#ffffff";
      };
      focused_match = {
        foreground = "#ffffff";
        background = "#000000";
      };
    };

    # keyboard hints 
    hints = {
      start = {
        foreground = "#1d1f21";
        background = "#e9ff5e";
      };
      end = {
        foreground = "#e9ff5e";
        background = "#1d1f21";
      };
    };

    # line indicator
    line_indicator = {
      foreground = "None";
      background = "None";
    };

    # footer bar 
    footer_bar = {
      foreground = "#c5c8c6";
      background = "#1d1f21";
    };

    # selection colors
    selection = {
      text = "CellBackground";
      background = "CellForeground";
    };

    # normal colors
    normal = {
      black   = "#1d1f21";
      red     = "#cc6666";
      green   = "#b5bd68";
      yellow  = "#f0c674";
      blue    = "#81a2be";
      magenta = "#b294bb";
      cyan    = "#8abeb7";
      white   = "#c5c8c6";
    };

    # bright colors
    bright = {
      black   = "#666666";
      red     = "#d54e53";
      green   = "#b9ca4a";
      yellow  = "#e7c547";
      blue    = "#7aa6da";
      magenta = "#c397d8";
      cyan    = "#70c0b1";
      white   = "#eaeaea";
    };

    # dim colors
    dim = {
      black   = "#131415";
      red     = "#864343";
      green   = "#777c44";
      yellow  = "#9e824c";
      blue    = "#556a7d";
      magenta = "#75617b";
      cyan    = "#5b7d78";
      white   = "#828482";
    };
  };

  # cursor
  cursor = {
    # cursor style (Block, Underline, Beam)
    style = {
      shape = "Block";
    };
    # cursor blinking state (Never, Off, On, Always)
    blinking = "Off";
  };
}
