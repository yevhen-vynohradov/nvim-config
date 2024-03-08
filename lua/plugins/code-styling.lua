return {
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
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
			})
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
}
