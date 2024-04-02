return {
	{
		"code-biscuits/nvim-biscuits",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
		config = function()
			local biscuits = require("nvim-biscuits")
			biscuits.setup({
				default_config = {
					max_length = 12,
					min_distance = 5,
					prefix_string = " 📎 ",
				},
				cursor_line_only = true,
				-- on_events = {
				-- 	"CursorHold",
				-- 	"CursorHoldI",
				-- 	"InsertLeave",
				-- },
				language_config = {
					vimdoc = {
						disabled = true,
					},
					html = {
						prefix_string = " 🌐 ",
					},
					javascript = {
						prefix_string = " ✨ ",
						max_length = 80,
					},
					typescript = {
						prefix_string = " ✨ ",
						max_length = 80,
					},
          python = {
						disabled = true,
					},
				},
			})
		end,
	},
}
