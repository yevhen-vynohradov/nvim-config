return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				css = { "stylelint" },
        scss = { "stylelint" },
        sass = { "stylelint" },
				html = { "htmlbeautifier" },
				json = { "jq" },
				yaml = { "yq" },
				markdown = { "markdownlint" },
				lua = { "stylua" },
        sql = { "sql-formatter" },
			},
			--format_on_save = {
			--lsp_fallback = true,
			--async = false,
			--timeout_ms = 1000,
			--},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
