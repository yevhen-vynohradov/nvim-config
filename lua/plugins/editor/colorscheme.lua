return {
  {
    "folke/styler.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      themes = {
        markdown = { colorscheme = "tokyonight" },
        help = { colorscheme = "tokyonight" },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "moon",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup(opts)
      tokyonight.load()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
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
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    lazy = true,
    name = "kanagawa"
  },
  {
    "sainnhe/gruvbox-material",
    enabled = false,
    lazy = true,
    name = "gruvbox-material"
  },
  {
    "sainnhe/everforest",
    enabled = false,
    lazy = true,
    name = "everforest",
    config = function()
      vim.cmd.colorscheme "gruvbox-material"
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    lazy = true,
    config = function()
      require("gruvbox").setup()
    end,
  },
  {
		"loctvl842/monokai-pro.nvim",
    enabled = false,
		config = function()
			require("monokai-pro").setup({
				transparent_background = false,
				terminal_colors = true,
				devicons = true, -- highlight the icons of `nvim-web-devicons`
				styles = {
					comment = { italic = true },
					keyword = { italic = true }, -- any other keyword
					type = { italic = true }, -- (preferred) int, long, char, etc
					storageclass = { italic = true }, -- static, register, volatile, etc
					structure = { italic = true }, -- struct, union, enum, etc
					parameter = { italic = true }, -- parameter pass in function
					annotation = { italic = true },
					tag_attribute = { italic = true }, -- attribute of tag in reactjs
				},
				filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
				-- Enable this will disable filter option
				day_night = {
					enable = false, -- turn off by default
					day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
					night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
				},
				inc_search = "background", -- underline | background
				background_clear = {
					-- "float_win",
					"toggleterm",
					"telescope",
					"which-key",
					"renamer",
					"notify",
					-- "nvim-tree",
					"neo-tree",
					"bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
				}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
				plugins = {
					bufferline = {
						underline_selected = false,
						underline_visible = false,
					},
					indent_blankline = {
						context_highlight = "pro", -- default | pro
						context_start_underline = false,
					},
				},
			})

			-- vim.cmd([[colorscheme monokai-pro]])
		end,
	},
}
