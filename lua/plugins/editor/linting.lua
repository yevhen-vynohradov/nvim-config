return {
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				markdown = { "markdownlint" },
				json = { "jsonlint" },
				-- css = { "stylelint" },
				-- scss = { "stylelint" },
				-- sass = { "stylelint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			local focus_target = function(target)
				local winid = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_cursor(winid, { target.lnum + 1, (target.col or 1) })
			end

			local bte = require("better-ts-errors")

			local previous = function()
				bte.disable()

				local target = vim.diagnostic.get_prev()
				if not target then
					return
				end
				focus_target(target)
				bte.enable()
			end

			local next = function()
				bte.disable()

				local target = vim.diagnostic.get_next()
				if not target then
					return
				end
				focus_target(target)
				bte.enable()
			end

			bte.setup({
				keymaps = {
					toggle = "<leader>dd", -- default '<leader>dd'
					go_to_definition = "<leader>dx", -- default '<leader>dx'
				},
			})

			vim.keymap.set("n", "]a", next, {
				desc = "Next TS error",
				noremap = true,
				silent = true,
			})
			vim.keymap.set("n", "[a", previous, {
				desc = "Previouse TS error",
				noremap = true,
				silent = true,
			})
		end,
	},
}
