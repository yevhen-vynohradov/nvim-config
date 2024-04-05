return {
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "VeryLazy",
    opts = {
      color = "#ef9062",
      use_colorpalette = false,
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
		"RRethy/vim-illuminate",
    enabled = true,
    event = "BufReadPost",
    opts = {
			modes_allowlist = { "n" },
			filetypes_denylist = {
				"dirbuf",
				"dirvish",
				"fugitive",
				"neo-tree",
			},
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},
			delay = 500,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			vim.cmd([[
                augroup illuminate_augroup
                    autocmd!
                    autocmd VimEnter * hi illuminatedWordRead cterm=none gui=none guibg=#526252
                    autocmd VimEnter * hi illuminatedWordText cterm=none gui=none guibg=#525252
                    autocmd VimEnter * hi illuminatedWordWrite cterm=none gui=none guibg=#625252
                augroup END
            ]])
		end,
	},
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
}