return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"SmiteshP/nvim-navic",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local winbar = require("core.utils.winbar")
		local utils = require("core.utils")
		local icons = require("core.icons")
		local navic = require("nvim-navic")
		-- configure lualine with modified theme
		-- lualine.setup({
		--   options = {
		--     theme = "tokyonight",
		--     -- theme = "monokai-pro",
		--   },
		--   sections = {
		--     lualine_x = {
		--       {
		--         lazy_status.updates,
		--         cond = lazy_status.has_updates,
		--         color = { fg = "#ff9e64" },
		--       },
		--       { "encoding" },
		--       { "fileformat" },
		--       { "filetype" },
		--     },
		--   },
		-- })

		-- Color table for highlights
		local colors = {
			bg = "#202328",
			fg = "#bbc2cf",
			yellow = "#ECBE7B",
			cyan = "#008080",
			darkblue = "#081633",
			green = "#98be65",
			orange = "#FF8800",
			violet = "#a9a1e1",
			magenta = "#c678dd",
			blue = "#51afef",
			red = "#ec5f67",
		}

		local function separator()
			return "%="
		end

		local function tab_stop()
			return icons.ui.Tab .. " " .. vim.bo.shiftwidth
		end

		-- local function loclist_open()
		--   local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
		--   return wininfo[1].loclist == 1
		-- end

		local function show_macro_recording()
			local rec_reg = vim.fn.reg_recording()
			if rec_reg == "" then
				return ""
			else
				return "recording @" .. rec_reg
			end
		end

		-- local function lsp_client(msg)
		-- 	msg = msg or ""
		-- 	local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
		--
		-- 	if next(buf_clients) == nil then
		-- 		if type(msg) == "boolean" or #msg == 0 then
		-- 			return ""
		-- 		end
		-- 		return msg
		-- 	end
		--
		-- 	local buf_ft = vim.bo.filetype
		-- 	local buf_client_names = {}
		--
		-- 	-- add client
		-- 	for _, client in pairs(buf_clients) do
		-- 		if client.name ~= "null-ls" then
		-- 			table.insert(buf_client_names, client.name)
		-- 		end
		-- 	end
		--
		-- 	-- add formatter
		-- 	local formatters = require("config.lsp.null-ls.formatters")
		-- 	local supported_formatters = formatters.list_registered(buf_ft)
		-- 	vim.list_extend(buf_client_names, supported_formatters)
		--
		-- 	-- add linter
		-- 	local linters = require("config.lsp.null-ls.linters")
		-- 	local supported_linters = linters.list_registered(buf_ft)
		-- 	vim.list_extend(buf_client_names, supported_linters)
		--
		-- 	-- add hover
		-- 	local hovers = require("config.lsp.null-ls.hovers")
		-- 	local supported_hovers = hovers.list_registered(buf_ft)
		-- 	vim.list_extend(buf_client_names, supported_hovers)
		--
		-- 	-- add code action
		-- 	local code_actions = require("config.lsp.null-ls.code_actions")
		-- 	local supported_code_actions = code_actions.list_registered(buf_ft)
		-- 	vim.list_extend(buf_client_names, supported_code_actions)
		--
		-- 	local hash = {}
		-- 	local client_names = {}
		-- 	for _, v in ipairs(buf_client_names) do
		-- 		if not hash[v] then
		-- 			client_names[#client_names + 1] = v
		-- 			hash[v] = true
		-- 		end
		-- 	end
		-- 	table.sort(client_names)
		-- 	return "" .. table.concat(client_names, ", ") .. ""
		-- end

		local config = {
			options = {
				icons_enabled = true,
				theme = "tokyonight",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {
						"help",
						"startify",
						"dashboard",
						"packer",
						"neogitstatus",
						"NvimTree",
						"neo-tree",
						"Trouble",
						"alpha",
						"lir",
						"Outline",
						"spectre_panel",
						"toggleterm",
						"dap-repl",
						"dapui_console",
						"dapui_watches",
						"dapui_stacks",
						"dapui_breakpoints",
						"dapui_scopes",
					},
				},
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ utils.get_repo_name },
					"branch",
					{ "diff", colored = true },
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							error = "DiagnosticError",
							warn = "DiagnosticWarn",
							info = "DiagnosticInfo",
							hint = "DiagnosticHint",
						},
						colored = true,
					},
					{ separator },
					{
						"macro-recording",
						fmt = show_macro_recording,
					},
					-- { separator },
					-- {
					-- 	lsp_client,
					-- 	icon = icons.ui.Code,
					-- 	-- color = { fg = colors.violet, gui = "bold" },
					-- 	on_click = function()
					-- 		vim.cmd([[LspInfo]])
					-- 	end,
					-- },
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = {
					"filename",
					{ tab_stop },
					"encoding",
					"fileformat",
					"filetype",
					"progress",
				},
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			-- tabline = {},
			winbar = {
				lualine_a = {
					"filename",
				},
				lualine_b = {
					-- {
					-- 	"navic",
					-- 	color_correction = nil,
					-- 	navic_opts = nil,
					-- },
					{
						winbar.get_winbar,
            color_correction = "dynamic",
						color = { fg = colors.violet, gui = "bold" },
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							error = "DiagnosticError",
							warn = "DiagnosticWarn",
							info = "DiagnosticInfo",
							hint = "DiagnosticHint",
						},
						colored = true,
            color_correction = "dynamic",
						on_click = function()
							vim.diagnostic.setloclist()
						end,
					},
				},
			},
			inactive_winbar = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					"diagnostics",
				},
			},
			extensions = { "neo-tree", "nvim-tree", "toggleterm", "quickfix" },
		}

		lualine.setup(config)
	end,
}
