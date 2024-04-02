return {
  { "itchyny/calendar.vim", cmd = { "Calendar" } },
  { "folke/twilight.nvim", config = true, cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },
  { "folke/zen-mode.nvim", config = true, cmd = { "ZenMode" } },
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  { "lukas-reineke/headlines.nvim", config = true, ft = { "markdown", "org", "norg" } },
  {
    "jbyuki/nabla.nvim",
    --stylua: ignore
    keys = {
      { "<leader>nN", function() require("nabla").popup() end, desc = "Notation", },
    },
    config = function()
      require("nabla").enable_virt()
    end,
  },
  {
    "vim-pandoc/vim-pandoc",
    event = "VeryLazy",
    enabled = false,
    dependencies = { "vim-pandoc/vim-pandoc-syntax" },
  },
  {
    "frabjous/knap",
    init = function()
      -- Configure vim.g.knap_settings
    end,
    --stylua: ignore
    keys = {
      { "<leader>np", function() require("knap").process_once() end, desc = "Preview", },
      { "<leader>nc", function() require("knap").close_viewer() end, desc = "Close Preview", },
      { "<leader>nt", function() require("knap").close_viewer() end, desc = "Toggle Preview", },
      { "<leader>nj", function() require("knap").forward_jump() end, desc = "Forward jump", },
      { "<leader>nn", function() require("utils.notepad").launch_notepad() end, desc = "Temporary Notepad", },
    },
    ft = { "markdown", "tex" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {},
        ltex = { filetypes = { "tex", "pandoc", "bib" } },
      },
    },
  },
  {
    "lervag/vimtex",
    ft = { "tex" },
    opts = { patterns = { "*.tex" } },
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = opts.patterns,
        callback = function()
          vim.cmd [[VimtexCompile]]
        end,
      })

      -- Live compilation
      vim.g.vimtex_compiler_latexmk = {
        build_dir = ".out",
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-synctex=1",
        },
      }
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_fold_enabled = true
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 0, -- default: 1
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    rocks = "luautf8",
    opts = {},
    enabled = false,
  },
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown" }, opts = {} },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  { "mzlogin/vim-markdown-toc", ft = { "markdown" } },
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      home = vim.env.HOME .. "/zettelkasten",
    },
    enabled = false,
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    opts = {
      dir = vim.env.HOME .. "/obsidian",
      completion = {
        nvim_cmp = true,
      },
    },
    enabled = false,
    ft = { "markdown" },
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow", enabled = true },
  { "toppair/peek.nvim", config = true, ft = { "markdown" }, enabled = false, build = "deno task --quiet build:fast" },
  -- glow.nvim
  -- https://github.com/rockerBOO/awesome-neovim#markdown-and-latex

  {
    "nvim-neorg/neorg",
    enabled = false,
    ft = { "norg" },
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.qol.toc"] = {},
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = vim.env.HOME .. "/norg-notes/",
            },
          },
        },
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
      },
    },
  },
  {
    "nvim-orgmode/orgmode",
    enabled = false,
    ft = { "org" },
    opts = {
      org_agenda_files = { vim.env.HOME .. "/org-notes/agenda/*" },
      org_default_notes_file = vim.env.HOME .. "/org-notes/default.org",
    },
    config = function(plugin, opts)
      require("orgmode").setup_ts_grammar()
      require("orgmode").setup(opts)
    end,
  },
  { "akinsho/org-bullets.nvim", enabled = false, config = true, ft = { "org" } },
}