# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # (import ./overlay.nix)
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "snikt";
    homeDirectory = "/home/snikt";
  };

  programs = {
    neovim = {
      enable = true;
    };
  };

  home.packages = with pkgs; [ alacritty ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
