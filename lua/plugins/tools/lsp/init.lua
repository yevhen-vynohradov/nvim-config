return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim",      cmd = "Neoconf", config = true },
			{ "j-hui/fidget.nvim",       config = true },
			{ "smjonas/inc-rename.nvim", config = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			{
				"b0o/SchemaStore.nvim",
				version = false,
			},
			{
				"folke/neodev.nvim",
				opts = {
					library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
				},
			},
		},
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
				-- html
				html = {
					filetypes = { "html", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				},
				-- Emmet
				emmet_ls = {
					init_options = {
						html = {
							options = {
								-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
								["bem.enabled"] = true,
							},
						},
					},
				},
				-- CSS
				cssls = {},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
							hint = {
								enable = false,
							},
						},
					},
				},
				yamlls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
						vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
					end,
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							format = {
								enable = true,
							},
							validate = { enable = true },
							schemaStore = {
								-- Must disable built-in schemaStore support to use
								-- schemas from SchemaStore.nvim plugin
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
						},
					},
				},
				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectory = { mode = "auto" },
					},
				},
				marksman = {},
			},
			setup = {
				lua_ls = function(_, _)
					local lsp_utils = require("plugins.tools.lsp.utils")
					lsp_utils.on_attach(function(client, buffer)
						-- stylua: ignore
						if client.name == "lua_ls" then
							vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end,
								{ buffer = buffer, desc = "OSV Run" })
							vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end,
								{ buffer = buffer, desc = "OSV Launch" })
						end
					end)
				end,
				eslint = function()
					vim.api.nvim_create_autocmd("BufWritePre", {
						callback = function(event)
							local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
							if client then
								local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
								if #diag > 0 then
									vim.cmd "EslintFixAll"
								end
							end
						end,
					})
				end,
			},
			format = {
				timeout_ms = 3000,
			},
		},
		config = function(plugin, opts)
			require("plugins.tools.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"shfmt",
				"hadolint",
				"prettierd",
				"stylua",
				"typescript-language-server",
				"js-debug-adapter",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

	-- {
	-- 	"williamboman/mason.nvim",
	-- 	dependencies = {
	-- 		"williamboman/mason-lspconfig.nvim",
	-- 		"WhoIsSethDaniel/mason-tool-installer.nvim",
	-- 	},
	-- 	config = function()
	-- 		-- import mason
	-- 		local mason = require("mason")

	-- 		-- import mason-lspconfig
	-- 		local mason_lspconfig = require("mason-lspconfig")

	-- 		local mason_tool_installer = require("mason-tool-installer")

	-- 		-- enable mason and configure icons
	-- 		mason.setup({
	-- 			ui = {
	-- 				border = "rounded",
	-- 				icons = {
	-- 					package_installed = "✓",
	-- 					package_pending = "➜",
	-- 					package_uninstalled = "✗",
	-- 				},
	-- 			},
	-- 		})

	-- 		mason_lspconfig.setup({
	-- 			-- list of servers for mason to install
	-- 			ensure_installed = {
	-- 				"cssls",
	-- 				"docker_compose_language_service",
	-- 				"dockerls",
	-- 				"emmet_ls",
	-- 				"html",
	-- 				"yamlls",
	-- 				"sqls",
	-- 				"tsserver",
	-- 				"lua_ls",
	-- 				"prismals",
	-- 			},
	-- 			-- auto-install configured servers (with lspconfig)
	-- 			automatic_installation = true, -- not the same as ensure_installed
	-- 		})

	-- 		mason_tool_installer.setup({
	-- 			ensure_installed = {
	-- 				"sql-formatter",
	-- 				"prettierd",  -- prettier formatter for ts, js, css, html, json, markdoun, yaml
	-- 				"stylua", -- lua formatter
	-- 				"eslint_d", -- js, ts linter
	-- 				"markdownlint",
	-- 				"commitlint",
	-- 				"jsonlint",
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		{ "antosha417/nvim-lsp-file-operations", config = true },
	-- 	},
	-- 	config = function()
	-- 		-- import lspconfig plugin
	-- 		local lspconfig = require("lspconfig")

	-- 		-- import cmp-nvim-lsp plugin
	-- 		local cmp_nvim_lsp = require("cmp_nvim_lsp")

	-- 		local keymap = vim.keymap -- for conciseness

	-- 		local opts = { noremap = true, silent = true }
	-- 		local on_attach = function(client, bufnr)
	-- 			opts.buffer = bufnr

	-- 			-- set keybinds
	-- 			opts.desc = "Show LSP references"
	-- 			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

	-- 			opts.desc = "Go to declaration"
	-- 			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

	-- 			opts.desc = "Show LSP definitions"
	-- 			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

	-- 			opts.desc = "Show LSP implementations"
	-- 			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

	-- 			opts.desc = "Show LSP type definitions"
	-- 			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

	-- 			opts.desc = "See available code actions"
	-- 			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

	-- 			opts.desc = "Smart rename"
	-- 			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

	-- 			opts.desc = "Show buffer diagnostics"
	-- 			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

	-- 			opts.desc = "Show line diagnostics"
	-- 			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

	-- 			opts.desc = "Go to previous diagnostic"
	-- 			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

	-- 			opts.desc = "Go to next diagnostic"
	-- 			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

	-- 			opts.desc = "Show documentation for what is under cursor"
	-- 			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

	-- 			opts.desc = "Restart LSP"
	-- 			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
	-- 		end

	-- 		-- used to enable autocompletion (assign to every lsp server config)
	-- 		local capabilities = cmp_nvim_lsp.default_capabilities()

	-- 		-- Change the Diagnostic symbols in the sign column (gutter)
	-- 		-- (not in youtube nvim video)
	-- 		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	-- 		for type, icon in pairs(signs) do
	-- 			local hl = "DiagnosticSign" .. type
	-- 			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	-- 		end

	-- 		-- configure html server
	-- 		lspconfig["html"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure typescript server with plugin
	-- 		lspconfig["tsserver"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure css server
	-- 		lspconfig["cssls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure prisma orm server
	-- 		lspconfig["prismals"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure emmet language server
	-- 		lspconfig["emmet_ls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
	-- 		})

	-- 		-- configure lua server (with special settings)
	-- 		lspconfig["lua_ls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 			settings = { -- custom settings for lua
	-- 				Lua = {
	-- 					-- make the language server recognize "vim" global
	-- 					diagnostics = {
	-- 						globals = { "vim" },
	-- 					},
	-- 					workspace = {
	-- 						-- make language server aware of runtime files
	-- 						library = {
	-- 							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
	-- 							[vim.fn.stdpath("config") .. "/lua"] = true,
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		})

	-- 		-- configure css modules
	-- 		-- lspconfig["cssmodules_ls"].setup({
	-- 		-- 	capabilities = capabilities,
	-- 		-- 	on_attach = on_attach,
	-- 		-- })

	-- 		-- configure prisma orm server
	-- 		lspconfig["docker_compose_language_service"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure prisma orm server
	-- 		lspconfig["dockerls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure prisma orm server
	-- 		lspconfig["yamlls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure prisma orm server
	-- 		lspconfig["sqls"].setup({
	-- 			capabilities = capabilities,
	-- 			on_attach = on_attach,
	-- 		})

	-- 		-- configure prisma orm server
	-- 		-- lspconfig["stylelint_lsp"].setup({
	-- 		-- 	capabilities = capabilities,
	-- 		-- 	on_attach = on_attach,
	-- 		-- })
	-- 	end,
	-- },

	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		enabled = false, -- use lspsaga
		config = true,
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>ld", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
			{ "<leader>lD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		opts = {
			symbol_in_winbar = {
				enable = false,
			},
			lightbulb = {
				enable = false,
			},
		},
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "VeryLazy",
		enabled = function()
			return vim.fn.has "nvim-0.10.0" == 1
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.shfmt,
					nls.builtins.diagnostics.hadolint,
					nls.builtins.formatting.prettierd,
					nls.builtins.formatting.stylua,
				},
			}
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
		opts = {
			tsserver_file_preferences = {
				-- Inlay Hints
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		config = function(_, opts)
			require("plugins.tools.lsp.utils").on_attach(function(client, bufnr)
				if client.name == "tsserver" then
					vim.keymap.set("n", "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>",
						{ buffer = bufnr, desc = "Organize Imports" })
					vim.keymap.set("n", "<leader>lO", "<cmd>TSToolsSortImports<cr>", { buffer = bufnr, desc = "Sort Imports" })
					vim.keymap.set("n", "<leader>lu", "<cmd>TSToolsRemoveUnused<cr>", { buffer = bufnr, desc = "Removed Unused" })
					vim.keymap.set("n", "<leader>lz", "<cmd>TSToolsGoToSourceDefinition<cr>",
						{ buffer = bufnr, desc = "Go To Source Definition" })
					vim.keymap.set("n", "<leader>lR", "<cmd>TSToolsRemoveUnusedImports<cr>",
						{ buffer = bufnr, desc = "Removed Unused Imports" })
					vim.keymap.set("n", "<leader>lF", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr, desc = "Fix All" })
					vim.keymap.set("n", "<leader>lA", "<cmd>TSToolsAddMissingImports<cr>",
						{ buffer = bufnr, desc = "Add Missing Imports" })
				end
			end)
			require("typescript-tools").setup(opts)
		end,
	},
	-- {
	-- 	"nvimtools/none-ls.nvim", -- configure formatters & linters
	-- 	lazy = true,
	-- 	-- event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
	-- 	dependencies = {
	-- 		"jay-babu/mason-null-ls.nvim",
	-- 	},
	-- 	config = function()
	-- 		local mason_null_ls = require("mason-null-ls")

	-- 		local null_ls = require("null-ls")

	-- 		local null_ls_utils = require("null-ls.utils")

	-- 		mason_null_ls.setup({
	-- 			ensure_installed = {
	-- 				"prettier", -- prettier formatter
	-- 				"stylua", -- lua formatter
	-- 				"eslint_d", -- js linter
	-- 			},
	-- 		})

	-- 		-- for conciseness
	-- 		local formatting = null_ls.builtins.formatting -- to setup formatters
	-- 		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

	-- 		-- to setup format on save
	-- 		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	-- 		-- configure null_ls
	-- 		null_ls.setup({
	-- 			-- add package.json as identifier for root (for typescript monorepos)
	-- 			root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
	-- 			-- setup formatters & linters
	-- 			sources = {
	-- 				--  to disable file types use
	-- 				--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
	-- 				formatting.prettier.with({
	-- 					extra_filetypes = { "svelte" },
	-- 				}), -- js/ts formatter
	-- 				formatting.stylua, -- lua formatter
	-- 				diagnostics.eslint_d.with({ -- js/ts linter
	-- 					condition = function(utils)
	-- 						return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
	-- 					end,
	-- 				}),
	-- 			},
	-- 			-- configure format on save
	-- 			on_attach = function(current_client, bufnr)
	-- 				if current_client.supports_method("textDocument/formatting") then
	-- 					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 					vim.api.nvim_create_autocmd("BufWritePre", {
	-- 						group = augroup,
	-- 						buffer = bufnr,
	-- 						callback = function()
	-- 							vim.lsp.buf.format({
	-- 								filter = function(client)
	-- 									--  only use null-ls for formatting instead of lsp server
	-- 									return client.name == "null-ls"
	-- 								end,
	-- 								bufnr = bufnr,
	-- 							})
	-- 						end,
	-- 					})
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	{ "jay-babu/mason-null-ls.nvim", opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false } },
	-- {
	--   "ray-x/lsp_signature.nvim",
	--   event = "VeryLazy",
	--   opts = {},
	-- },
	-- { "rafcamlet/nvim-luapad", cmd = { "LuaRun", "Luapad" } },

	{
		"mfussenegger/nvim-lint",
		enabled = false,
		event = "BufReadPre",
		opts = { ft = {} },
		config = function(_, opts)
			require("lint").linters_by_ft = opts.ft
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"dnlhc/glance.nvim",
		enabled = false,
		cmd = { "Glance" },
		opts = {},
	},
	{
		"luckasRanarison/clear-action.nvim",
		enabled = false,
		event = "VeryLazy",
		cmd = { "CodeActionToggleSigns", "CodeActionToggleLabel" },
		opts = {},
	},
}
