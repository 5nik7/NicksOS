{ lib, pkgs, config, ... }:

let
  nixos-wsl = import ./nixos-wsl;
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-enviroment";
    executable = true;

    text = ''
      dbus-update-activation-enviroment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
      systemctl --user start xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    '';
  };
in
{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  time.timeZone = "America/Los_Angeles";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "snikt";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

 hardware.opengl.enable = true;

 services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    git
    home-manager
    fd
    fzf
    htop
    btop
    neofetch
    ranger
    ripgrep
    unrar
    unzip
    wget
    neovim
    exa
    bat
    clang
    clang-tools
    gnumake
    ninja
    direnv
    nixfmt
    nixpkgs-fmt
    zsh
    starship
    lxappearance
    wayland
    xdg-utils
    sway
    swaybg
    waybar
    xwayland
    vscode
    kitty
    firefox
    google-chrome
    xfce.thunar
    wofi
    nwg-bar
    catppuccin-gtk
    catppuccin-cursors
    catppuccin-papirus-folders
    dbus-sway-environment
    polkit_gnome
    lolcat
    fzf-zsh
    rnix-lsp
    luajit
    lazygit
    python3
    nodejs
    nodePackages.yarn
    nodePackages.typescript
    nodePackages.live-server
    nodePackages.prettier
  ];

 environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  users.users.snikt = {
    isNormalUser = true;
    home = "/home/snikt";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    uid = 1000;
  };

  fonts = {
  fonts = with pkgs; [
    material-design-icons
    emacs-all-the-icons-fonts
    inter
    material-icons
    material-design-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    twemoji-color-font
    (nerdfonts.override {fonts = [ "JetBrainsMono" "Hack" "FiraCode" "DroidSansMono" "FiraMono" ]; })
    ];
  };

  programs = {
    dconf = {
      enable = true;
    };
    zsh = {
      enable = true;
      shellAliases = {
        c = "clear";
        q = "exit";
        v = "nvim";
        d = "ranger";
        cat = "bat";
        ".." = "cd ..";
        l = "exa -la --icons --no-filesize --no-user --no-time --group-directories-first";
        ll = "exa -la --icons --no-filesize --no-user --no-time --group-directories-first";
        update = "sudo nixos-rebuild switch";
      };
      enableCompletion = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      histFile = "$HOME/.zsh_history";
      histSize = 10000;
    };
    nix-index = {
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      settings = {
				format = "$username$hostname$directory$git_branch$git_status$character";
        username = {
          show_always = true;
          style_root = "red";
          style_user = "white";
          format = "[ ]($style) ";
        };
				directory = {
        	style = "bold blue";
					};
				git_branch = {
        	format = "[ $branch](bold yellow) ";
					};
        git_status = {
          format = "([ $all_status](bold yellow) )";
        };
        character = {
          success_symbol = "[](green)";
          error_symbol = "[](red)";
         };
      };
		};
    neovim = {
      enable = true;
      withRuby = true;
      withPython3 = true;
      withNodeJs = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    sway = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
  };


  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
    };
  };

  networking = {
    hostName = "Zoo";
  };

   nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "23.05";
}
