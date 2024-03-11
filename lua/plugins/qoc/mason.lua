return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "cssls",
        "cssmodules_ls",
        "docker_compose_language_service",
        "dockerls",
        "emmet_ls",
        "html",
        "yamlls",
        "sqls",
        "stylelint_lsp",
        "tsserver",
        "lua_ls",
        "prismals",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "htmlbeautifier",
        "sql-formatter",
        "prettier", -- prettier formatter
        "prettierd",
        "stylua", -- lua formatter
        "eslint_d", -- js linter
        "markdownlint",
        "stylelint",
        "jq",
        "commitlint",
        "yamlfmt",
        "jsonlint",
        "yq",
      },
    })
  end,
}

