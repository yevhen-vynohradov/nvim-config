return {
  {
    "tpope/vim-dadbod",
    enabled = true,
    cond = function()
      local config = require('config')
      if not config.tools.database then
        return
      end
    end,
    lazy = true,
    opts = {
      db_competion = function()
        require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
      end,
    },
    config = function(_, opts)
      vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
        },
        command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
          "mysql",
          "plsql",
        },
        callback = function()
          vim.schedule(opts.db_completion)
        end,
      })
    end,
    keys = {
      { "<leader>Dt", "<cmd>DBUIToggle<cr>",        desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },
  {
		"kristijanhusak/vim-dadbod-ui",
    enabled = true,
    cond = function()
      local config = require('config')
      if not config.tools.database then
        return
      end
    end,
    lazy = true,
    dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DB", "DBUI" },
		ft = { "sql", "mysql", "plsql" },
		config = function()
			vim.g.db_ui_save_location = vim.fn.getcwd() .. "/sql/"
		end,
	},
  {
		"kristijanhusak/vim-dadbod-completion",
    enabled = true,
    cond = function()
      local config = require('config')
      if not config.tools.database then
        return
      end
    end,
		lazy = true,
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-ui",
    },
    -- TODO: solve this duplication 
		config = function()
			vim.cmd([[
                autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni
                autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
            ]])
		end,
	},
  {
    "kkharji/sqlite.lua"
  },
}
