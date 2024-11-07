{ config, pkgs, lib, ... }:
{
      home = {
        stateVersion = "24.05";
        username = "mh3th";
        homeDirectory = "/home/mh3th";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          bind = 
          [
            "$mod, t, exec, kitty"
            "$mod, b, exec, firefox"
            "$mod, q, killactive"
            "$mod, f, fullscreen, toggle"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod SHIFT, j, movewindow, d"
            "$mod SHIFT, k, movewindow, u"
            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, l, movewindow, r"
            "$mod, SPACE, exec, rofi -show"
                  
          ]
          ++(
              builtins.concatLists (builtins.genList (i:
                let ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );

          decoration = {
            rounding = 10;
            drop_shadow = false;
            blur.enabled = false;

          };
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            "col.active_border" = "rgba(00ffff99)";
          };
          input = {
            kb_layout = "us,ru";
            kb_options = "grp:alt_shift_toggle";
          };
          windowrulev2 = [
            "opacity 0.85 0.7, class:^(kitty)$"
            "opacity 0.85 0.7, class:^(firefox)$"
            "opacity 0.85 0.7, class:^(rofi)$"
          ];
    };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit =
            ''
            fastfetch
            '';
    loginShellInit =
            ''
            set fish_greeting ""
            hyprland
            '';
    plugins=
    [
            {
                    name = "z";
                    src = pkgs.fetchFromGitHub {
                            owner = "jethrokuan";
                            repo = "z";
                            rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
                            sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
                    };
            }

            {
                    name = "fasd";
                    src = pkgs.fetchFromGitHub {
                            owner = "oh-my-fish";
                            repo = "plugin-fasd";
                            rev = "38a5b6b6011106092009549e52249c6d6f501fba";
                            sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
                    };
            }
    ];
    shellAliases = {
      my-switch-nixos-rebuild-flake = "sudo nixos-rebuild switch --flake ~/nixos#penetration";
      my-switch-home-flake = "home-manager switch --flake ~/nixos";
    };
  };
  programs.kitty = {
          enable = true;
          shellIntegration.enableFishIntegration = true;
          settings = {
                  confirm_os_window_close = -1;
          };
  };
  programs.waybar = {
          enable = true;
          systemd = {
                  enable = true;
                  target = "hyprland-session.target";
                  };
          settings = {
                  mainBar = {
                          layer = "top";
                          position = "top";
                          height = 30;
                          modules-left = [ "hyprland/workspaces" "hyprland/submode" ];
                          modules-center = [ "hyprland/window" ];
                          modules-right = ["pulseaudio" "battery" "clock" ];

                          "hyprland/workspaces" = {
                                  disable-scroll = true;
                                  all-outputs = true;
                          };
                          pulseaudio = {
                                  format = "{icon}  {volume}%";
                                  format-muted = " Muted";
                                  format-icons = {
                                          headphone = "";
                                          hands-free = "";
                                          headset = "";
                                          phone = "";
                                          portable = "";
                                          car = "";
                                          default = ["" "" ""];
                                  };
                                  on-click = "pavucontrol";
                          };
                  };
          };
          style = (builtins.readFile ./waybar.css);
  };
  programs.rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          location = "center";

          theme = "/etc/nixos/rofi.rasi";

          extraConfig = {
                  modi = "drun";
                  icon-theme = "Oranchelo";
                  show-icons = true;
                  terminal = "kitty";
                  display-drun = "Apps";
          };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/etc/nixos/sea.jpg" ];
      wallpaper = [ ", /etc/nixos/sea.jpg" ];
    };
  };
  programs.nixvim = {
    opts = {
      number = true;        
      relativenumber = true;
      shiftwidth = 2;      
      clipboard = "unnamedplus";
    };
    globals = { mapleader = " "; maplocalleader = " "; };
    enable = true;
    enableMan = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      lualine.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
        };
      };
      nix.enable = true;
      treesitter = {
        enable = true;
      };
      cmp = {
        enable = true;
        settings = {
          formatting = { fields = [ "kind" "abbr" "menu" ]; };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { 
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
        };
      };
      cmp-nvim-lsp = {
        enable = true; # LSP
      };
      cmp-buffer = {
        enable = true;
      };
      cmp-path = {
        enable = true; # file system paths
      };
      cmp_luasnip = {
        enable = true; # snippets
      };
      cmp-cmdline = {
        enable = true; # autocomplete for cmdline
      };
      lsp = {
        enable = true;
        servers = {
          nil-ls.enable = true;
          tailwindcss.enable = true;
          html.enable = true;
          rust-analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
        };
      };
    };
  };
}
