return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		local bufferline = require("bufferline")

		local keymap = vim.keymap

		keymap.set("n", "<leader>j", ":BufferLineCyclePrev<CR>", { silent = true })
		keymap.set("n", "<leader>k", ":BufferLineCycleNext<CR>", { silent = true })
		keymap.set("n", "gb", ":BufferLinePick<CR>", { silent = true })

		-- local mocha = require("catppuccin.palettes").get_palette("mocha")

		bufferline.setup({
			options = {
				mode = "buffers",
				style_preset = bufferline.style_preset.no_italic,
				show_tab_indicators = true,
				separator_style = "thick",
				show_buffer_close_icons = true,
				show_close_icon = true,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function()
					return " "
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
				custom_areas = {
					right = function()
						local result = {}
						local seve = vim.diagnostic.severity
						local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
						local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
						local info = #vim.diagnostic.get(0, { severity = seve.INFO })
						local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

						if error ~= 0 then
							table.insert(result, { text = "  " .. error, fg = "#EC5241" })
						end

						if warning ~= 0 then
							table.insert(result, { text = "  " .. warning, fg = "#EFB839" })
						end

						if hint ~= 0 then
							table.insert(result, { text = "  " .. hint, fg = "#A3BA5E" })
						end

						if info ~= 0 then
							table.insert(result, { text = "  " .. info, fg = "#7EA9A7" })
						end
						return result
					end,
				},
				color_icons = true,
				numbers = "ordinal",
				indicator = {
					icon = "▎", -- this should be omitted if indicator style is not 'icon'
					style = "icon",
				},
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				buffer_close_icon = " 󰅖 ",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
			},
		})
	end,
}
