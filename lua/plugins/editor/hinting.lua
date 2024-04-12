return {
  {
    -- A Neovim plugin helping you establish good command workflow and habit
    "m4xshen/hardtime.nvim",
    enabled = true,
    cmd = { "HardTime" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
  {
    -- Code Biscuits are in-editor annotations usually at the end of 
    -- a closing tag/bracket/parenthesis/etc. They help you get the 
    -- context of the end of that AST node so you don't have to 
    -- navigate to find it.
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
        -- TODO: extract it to pde files
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
  {
    -- Define your keymaps, commands, and autocommands as simple 
    -- Lua tables, building a legend at the same time
    "mrjones2014/legendary.nvim",
    keys = {
      { "<C-S-p>",    "<cmd>Legendary<cr>", desc = "Legendary" },
      { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      which_key = { auto_register = true },
    },
  },
  {
    -- WhichKey is a lua plugin for Neovim 0.5 that displays a popup with 
    -- possible key bindings of the command you started typing. 
    "folke/which-key.nvim",
    cond = function()
      return require("config").keymenu.which_key
    end,
    dependencies = {
      "mrjones2014/legendary.nvim",
    },
    event = "VeryLazy",
    opts = {
      setup = {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
        window = {
          border = "single",        -- none, single, double, shadow
          position = "bottom",      -- bottom, top
          margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
          padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3,                    -- spacing between columns
          align = "left",                 -- align columns left, center or right
        },
      },
      defaults = {
        prefix = "<leader>",
        mode = { "n", "v" },
        w = { "<cmd>update!<CR>", "Save" },
        -- stylua: ignore
        q = {
          name = "Quit/Session",
          q = { function() require("utils").quit() end, "Quit", },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        a = { name = "+AI" },
        b = { name = "+Buffer" },
        d = { name = "+Debug" },
        D = { name = "+Database" },
        -- stylua: ignore
        f = {
          name = "+File",
          t = { function() require("utils").open_term("yazi") end, "Terminal File Manager", },
        },
        h = { name = "+Help" },
        j = { name = "+Jump" },
        g = { name = "+Git", h = { name = "+Hunk" }, t = { name = "+Toggle" }, w = { name = "+Work Tree" } },
        n = { name = "+Notes" },
        p = { name = "+Project" },
        -- o = { name = "+Orgmode" },
        r = { name = "+Refactor" },
        t = { name = "+Test", N = { name = "+Neotest" }, o = { "+Overseer" } },
        v = { name = "+View" },
        z = { name = "+System" },
        -- stylua: ignore
        s = {
          name = "+Search",
          c = { function() require("utils.coding").cht() end, "Cheatsheets", },
          o = { function() require("utils.coding").stack_overflow() end, "Stack Overflow", },
        },
        l = {
          name = "+Language",
          g = { name = "Annotation" },
          x = {
            name = "Swap Next",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
          X = {
            name = "Swap Previous",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts.setup)
      wk.register(opts.defaults)
    end,
  },
  {
    -- A Neovim plugin that renders a keyboard displaying 
    -- which keys have assigned actions.
    "jokajak/keyseer.nvim",
    enabled = false,
    opts = {},
    event = "VeryLazy",
    cmd = { "KeySeer" },
  },
  {
    -- Show next key clues
    "echasnovski/mini.clue",
    cond = function()
      return require("config").keymenu.mini_clue
    end,
    event = "VeryLazy",
    opts = function()
      local map_leader = function(suffix, rhs, desc)
        vim.keymap.set({ "n", "x" }, "<Leader>" .. suffix, rhs, { desc = desc })
      end
      map_leader("w", "<cmd>update!<CR>", "Save")
      map_leader("qq", require("utils").quit, "Quit")
      map_leader("qt", "<cmd>tabclose<cr>", "Close Tab")
      map_leader("sc", require("utils.coding").cht, "Cheatsheets")
      map_leader("so", require("utils.coding").stack_overflow, "Stack Overflow")

      local miniclue = require("mini.clue")
      return {
        window = {
          delay = vim.o.timeoutlen,
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          { mode = "n", keys = "<Leader>a",   desc = "+AI" },
          { mode = "x", keys = "<Leader>a",   desc = "+AI" },
          { mode = "n", keys = "<Leader>b",   desc = "+Buffer" },
          { mode = "n", keys = "<Leader>d",   desc = "+Debug" },
          { mode = "x", keys = "<Leader>d",   desc = "+Debug" },
          { mode = "n", keys = "<Leader>D",   desc = "+Database" },
          { mode = "n", keys = "<Leader>f",   desc = "+File" },
          { mode = "n", keys = "<Leader>h",   desc = "+Help" },
          { mode = "n", keys = "<Leader>j",   desc = "+Jump" },
          { mode = "n", keys = "<Leader>g",   desc = "+Git" },
          { mode = "x", keys = "<Leader>g",   desc = "+Git" },
          { mode = "n", keys = "<Leader>gh",  desc = "+Hunk" },
          { mode = "x", keys = "<Leader>gh",  desc = "+Hunk" },
          { mode = "n", keys = "<Leader>gt",  desc = "+Toggle" },
          { mode = "n", keys = "<Leader>n",   desc = "+Notes" },
          { mode = "n", keys = "<Leader>l",   desc = "+Language" },
          { mode = "x", keys = "<Leader>l",   desc = "+Language" },
          { mode = "n", keys = "<Leader>lg",  desc = "+Annotation" },
          { mode = "n", keys = "<Leader>lx",  desc = "+Swap Next" },
          { mode = "n", keys = "<Leader>lxf", desc = "+Function" },
          { mode = "n", keys = "<Leader>lxp", desc = "+Parameter" },
          { mode = "n", keys = "<Leader>lxc", desc = "+Class" },
          { mode = "n", keys = "<Leader>lX",  desc = "+Swap Previous" },
          { mode = "n", keys = "<Leader>lXf", desc = "+Function" },
          { mode = "n", keys = "<Leader>lXp", desc = "+Parameter" },
          { mode = "n", keys = "<Leader>lXc", desc = "+Class" },
          { mode = "n", keys = "<Leader>p",   desc = "+Project" },
          { mode = "n", keys = "<Leader>q",   desc = "+Quit/Session" },
          { mode = "x", keys = "<Leader>q",   desc = "+Quit/Session" },
          { mode = "n", keys = "<Leader>r",   desc = "+Refactor" },
          { mode = "x", keys = "<Leader>r",   desc = "+Refactor" },
          { mode = "n", keys = "<Leader>s",   desc = "+Search" },
          { mode = "x", keys = "<Leader>s",   desc = "+Search" },
          { mode = "n", keys = "<Leader>t",   desc = "+Test" },
          { mode = "n", keys = "<Leader>tN",  desc = "+Neotest" },
          { mode = "n", keys = "<Leader>to",  desc = "+Overseer" },
          { mode = "n", keys = "<Leader>v",   desc = "+View" },
          { mode = "n", keys = "<Leader>z",   desc = "+System" },

          -- Submodes
          { mode = "n", keys = "<Leader>tNF", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNL", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNa", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNf", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNl", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNn", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNN", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNo", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNs", postkeys = "<Leader>tN" },
          { mode = "n", keys = "<Leader>tNS", postkeys = "<Leader>tN" },

          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows {
            submode_move = false,
            submode_navigate = false,
            submode_resize = true,
          },
          miniclue.gen_clues.z(),
        },
      }
    end,
  },
}
