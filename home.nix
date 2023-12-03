{
  # secrets,
  config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
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
    jq
    killall
    mosh
    neovim
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
    sway
    xwayland
    waybar
    swww
    tealdeer
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" "FiraCode" "DroidSansMono" "FiraMono" ]; })
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
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  home.file.".config/nvim/init.lua".text = ''
    -- bootstrap lazy.nvim, LazyVim and your plugins
    require("config.lazy")
  '';
  home.file.".config/nvim/stylua.toml".text = ''
    indent_type = "Spaces"
    indent_width = 2
    column_width = 120
  '';
  home.file.".config/nvim/.neoconf.json".text = ''
    {
    "neodev": {
        "library": {
        "enabled": true,
        "plugins": true
        }
    },
    "neoconf": {
        "plugins": {
        "lua_ls": {
            "enabled": true
        }
        }
    }
    }
  '';
  home.file.".config/nvim/lua/config/autocmds.lua".text = ''
    -- Autocmds are automatically loaded on the VeryLazy event
    -- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
    -- Add any additional autocmds here
  '';
  home.file.".config/nvim/lua/config/keymaps.lua".text = ''
    -- Keymaps are automatically loaded on the VeryLazy event
    -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
    -- Add any additional keymaps here
  '';
  home.file.".config/nvim/lua/config/lazy.lua".text = ''
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
    end
    vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

    require("lazy").setup({
    spec = {
        -- add LazyVim and import its plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- import any extras modules here
        -- { import = "lazyvim.plugins.extras.lang.typescript" },
        -- { import = "lazyvim.plugins.extras.lang.json" },
        -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
        -- import/override with your plugins
        { import = "plugins" },
    },
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = false,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
        rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
            "gzip",
            -- "matchit",
            -- "matchparen",
            -- "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
        },
        },
    },
    })
  '';
  home.file.".config/nvim/lua/config/options.lua".text = ''
    local opt = vim.opt

    opt.guicursor = {
      "a:block",
      "n:Cursor",
      "o-c:iCursor",
      "v:vCursor",
      "i-ci-sm:ver30-iCursor",
      "r-cr:hor20-rCursor",
      "a:blinkon0",
    }
  '';
  home.file.".config/nvim/lua/plugins/init.lua".text = ''
    return {
      {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        opts = {
          flavour = "mocha",
          transparent_background = true,
          term_colors = true,
          styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
          },
          dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.50,
          },
          integrations = {
            alpha = true,
            cmp = true,
            gitsigns = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            lsp_trouble = true,
            mini = {
              enabled = true,
              indentscope_color = "overlay0",
            },
            native_lsp = {
              enabled = true,
              virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
              },
              underlines = {
                errors = { "undercurl" },
                hints = { "undercurl" },
                warnings = { "undercurl" },
                information = { "undercurl" },
              },
            },
            navic = { enabled = true, custom_bg = "lualine" },
            neotest = true,
            noice = true,
            notify = true,
            nvimtree = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            which_key = true,
          },
        },
      },
      {
        "LazyVim/LazyVim",
        opts = {
          colorscheme = "catppuccin",
        },
      },
      {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#181825",
    },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
╔══╗╔══╗╔═════╗╔══════██╗   ██╗██╗██╗╔═══╗╔═══╗
║  \║  ║║  ╔══╝║  ╔═╗ ██║   ██║██║██║║   \/   ║
║   \  ║║  ╚══╗║  ║ ║ ██║   ██║██║██║║  \  /  ║
║  \   ║║  ╔══╝║  ║ ║ ╚██╗ ██╔╝██║██║║  ║\/║  ║
║  ║\  ║║  ╚══╗║  ╚═╝  ║████╔╝ ██║██║║  ║  ║  ║
╚══╝╚══╝╚═════╝╚═══════╝╚═══╝  ╚═╝╚═╝╚══╝  ╚══╝
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
            { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        follow_current_file = { enabled = true },
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },
  },
  {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup()
  end,
  opts = {},
},
}
  '';

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "plain";
        theme = "base16";
      };
    };

    starship.enable = true;
    starship.settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      username.format = "[$user@](green)";
      username.show_always = true;
      hostname.ssh_only = false;
      hostname.style = "green";
      character.success_symbol = "[](green)";
      character.error_symbol = "[](red)";
      character.vimcmd_symbol = "[](blue)";
      character.vimcmd_visual_symbol = "[](pink)";
      character.vimcmd_replace_symbol = "[](orange)";
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
      defaultKeymap = "emacs";
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
        "..." = "./..";
        "...." = "././..";
        cd = "z";
        gc = "nix-collect-garbage --delete-old";
        refresh = "source ${config.home.homeDirectory}/.zshrc";
        rebuild = "sudo nixos-rebuild switch --flake ~/configuration";
        show_path = "echo $PATH | tr ':' '\n'";
	      l = "eza -la --icons --hyperlink --git";
	      c = "clear";
	      d = "ranger";
	      q = "exit";
	      v = "nvim";
	      path = "echo $PATH | tr ':' '\n'";

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
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
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

        WORDCHARS='*?[]~=&;!#$%^(){}<>'

        # fixes duplication of commands when using tab-completion
        export LANG=C.UTF-8
      '';
    };
  };
}