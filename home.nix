{
  # secrets,
  config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    wl-clipboard
    cliphist
    figlet
    toilet
    lolcat
    cmatrix
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    btop
    jq
    killall
    mosh
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
    ranger
    eza
    neofetch
    nix-zsh-completions
    zsh-fzf-tab
    nwg-look
    sway
    pywal
    swayest-workstyle
    autotiling-rs
    flashfocus
    rofi-wayland
    xfce.thunar
    firefox
    xwayland
    waybar
    kitty
    swaybg
    tealdeer
    lazygit
    wttrbar
    yazi
    nurl
    nix-init
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" "FiraCode" "DroidSansMono" "FiraMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    material-design-icons
    material-icons
    font-awesome
  ];

  stable-packages = with pkgs; [

    # key tools
    gnumake # for lunarvim
    gcc # for lunarvim
    gh # for bootstrapping
    just

    # core languages
    rustup
    go
    lua
    nodejs
    python
    typescript

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    ccls # c / c++
    gopls
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix
    nodePackages.pyright

    # formatters and linters
    alejandra # nix
    black # python
    ruff # python
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "${pkgs.neovim}/bin/nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    [
      pkgs.neovim-nightly
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;


    starship.enable = true;
    starship.settings = {
      add_newline = false;
      format = "$line_break[ ](black)$username$hostname$directory$git_branch$git_status$line_break[  ](black)$character";
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.symbol = "";
      git_branch.format = "[$symbol $branch]($style) ";
      git_branch.style = "yellow";
      directory.format = "[$path]($style) ";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 0;
      python.disabled = true;
      ruby.disabled = true;
      username.format = "[$user]($style)";
      username.style_user = "purple";
      username.style_root = "purple";
      username.show_always = true;
      hostname.format = "[@$hostname]($style) ";
      hostname.ssh_only = false;
      hostname.style = "purple";
      character.success_symbol = "[](cyan)";
      character.error_symbol = "[](cyan)";
      character.vimcmd_symbol = "[](blue)";
      character.vimcmd_visual_symbol = "[](pink)";
      character.vimcmd_replace_symbol = "[](orange)";
      character.format = "$symbol ";
    };

    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "plain";
        theme = "base16";
      };
    };

    fzf.enable = true;
    fzf.enableZshIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = false;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    broot.enable = true;
    broot.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    gh.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "nickflip86@gmail.com";
      userName = "5nik7";
      extraConfig = {
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        # };
        color.ui = true;
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      history.size = 10000;
      history.save = 10000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];

      shellAliases = {
      	".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        "......." = "cd ../../../../../..";
        "........" = "cd ../../../../../../..";
        cd = "z";
        gc = "nix-collect-garbage --delete-old";
        refresh = "source ${config.home.homeDirectory}/.zshrc";
        rebuild = "sudo nixos-rebuild switch --flake ~/configuration";
        show_path = "echo $PATH | tr ':' '\n'";
        l = "eza -lA --git --git-repos --icons  --group-directories-first --no-quotes --no-permissions --no-filesize --no-user --no-time";
        ll = "eza -lA --git --git-repos --icons --group-directories-first --no-quotes";
        c = "clear";
        q = "exit";
        v = "nvim";
        sv = "sudo nvim";
        path = "echo $PATH | tr ':' '\n'";
        lg = "lazygit";

        gapa = "git add --patch";
        grpa = "git reset --patch";
        gst = "git status";
        gdh = "git diff HEAD";
        gp = "git push";
        gph = "git push -u origin HEAD";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcm = "git checkout master";
        gcd = "git checkout develop";

        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/bin/pwsh/pwsh.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
        export PATH=$PATH:/mnt/c/vscode/bin
      '';

      initExtra = ''
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^e' end-of-line
        bindkey '^w' forward-word
        bindkey "^[[3~" delete-char
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word

        zstyle ':completion:*:*:*:*:*' menu select

        # Complete . and .. special directories
        zstyle ':completion:*' special-dirs true

        zstyle ':completion:*' list-colors ""
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

        # disable named-directories autocompletion
        zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

        # Use caching so that commands like apt and dpkg complete are useable
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

        # Don't complete uninteresting users
        zstyle ':completion:*:*:*:users' ignored-patterns \
                adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
                clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
                gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
                ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
                named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
                operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
                rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
                usbmux uucp vcsa wwwrun xfs '_*'
        # ... unless we really want to.
        zstyle '*' single-ignored complete

        # https://thevaluable.dev/zsh-completion-guide-examples/
        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        # mkcd is equivalent to takedir
        function mkcd takedir() {
          mkdir -p $@ && cd ''${@:$#}
        }

        function takeurl() {
          local data thedir
          data="$(mktemp)"
          curl -L "$1" > "$data"
          tar xf "$data"
          thedir="$(tar tf "$data" | head -n 1)"
          rm "$data"
          cd "$thedir"
        }

        function takegit() {
          git clone "$1"
          cd "$(basename ''${1%%.git})"
        }

        function take() {
          if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
            takeurl "$1"
          elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
            takegit "$1"
          else
            takedir "$@"
          fi
        }

        function ya() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd "$cwd"
          fi
          rm -f "$tmp"
        }
        alias d='ya'

        WORDCHARS='*?[]~=&;!#$%^(){}<>'

        # fixes duplication of commands when using tab-completion
        export LANG=C.UTF-8

        zle_highlight=('paste:none')
      '';
    };
  };
}
