return {

	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- animations
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		config = function()
			require("mini.animate").setup({
				scroll = {
					enable = false,
				},
			})
		end,
	},
	-- filename
	-- {
	-- 	"b0o/incline.nvim",
	-- 	event = "BufReadPre",
	-- 	priority = 1200,
	-- 	dependencies = {
	-- 		"SmiteshP/nvim-navic",
	-- 	},
	-- 	config = function()
	-- 		local helpers = require("incline.helpers")
	-- 		local navic = require("nvim-navic")
	-- 		local devicons = require("nvim-web-devicons")
	-- 		require("incline").setup({
	-- 			window = {
	-- 				padding = 0,
	-- 				margin = { horizontal = 0, vertical = 0 },
	-- 			},
	-- 			render = function(props)
	-- 				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
	-- 				if filename == "" then
	-- 					filename = "[No Name]"
	-- 				end
	-- 				local ft_icon, ft_color = devicons.get_icon_color(filename)
	-- 				local modified = vim.bo[props.buf].modified
	-- 				local res = {
	-- 					ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
	-- 						or "",
	-- 					" ",
	-- 					{ filename, gui = modified and "bold,italic" or "bold" },
	-- 					guibg = "#44406e",
	-- 				}
	-- 				if props.focused then
	-- 					for _, item in ipairs(navic.get_data(props.buf) or {}) do
	-- 						table.insert(res, {
	-- 							{ " > ", group = "NavicSeparator" },
	-- 							{ item.icon, group = "NavicIcons" .. item.type },
	-- 							{ item.name, group = "NavicText" },
	-- 						})
	-- 					end
	-- 				end
	-- 				table.insert(res, " ")
	-- 				return res
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = { enabled = true },
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"nvim-tree",
						"Trouble",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lazyterm",
					},
				},
			})
		end,
	},
	-- buffer remove
	{
		"echasnovski/mini.bufremove",

		keys = {
			{
				"<leader>bd",
				function()
					local bd = require("mini.bufremove").delete
					if vim.bo.modified then
						local choice =
							vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 1 then -- Yes
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then -- No
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = "Delete Buffer",
			},
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
		},
	},
}
