return {
  {
    "akinsho/bufferline.nvim",
    enabled = true,
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
          show_tab_indicators = false,
          separator_style = "thick",
          show_buffer_close_icons = true,
          show_close_icon = true,
          enforce_regular_tabs = false,
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
          custom_filter = function(buf_number, buf_numbers)
            local tab_num = 0
            for _ in pairs(vim.api.nvim_list_tabpages()) do
              tab_num = tab_num + 1
            end
  
            if tab_num > 1 then
              if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
                return true
              end
            else
              return true
            end
          end,
          sort_by = function(buffer_a, buffer_b)
            local mod_a = ((vim.loop.fs_stat(buffer_a.path) or {}).mtime or {}).sec or 0
            local mod_b = ((vim.loop.fs_stat(buffer_b.path) or {}).mtime or {}).sec or 0
            return mod_a > mod_b
          end,
        },
      })
    end,
  },
  -- {
  --   "akinsho/bufferline.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     options = {
  --       mode = "buffers", -- tabs or buffers
  --       numbers = "buffer_id",
  --       diagnostics = "nvim_lsp",
  --       always_show_bufferline = false,
  --       separator_style = "slant" or "padded_slant",
  --       show_tab_indicators = true,
  --       show_buffer_close_icons = false,
  --       show_close_icon = false,
  --       color_icons = true,
  --       enforce_regular_tabs = false,
  --       custom_filter = function(buf_number, _)
  --         local tab_num = 0
  --         for _ in pairs(vim.api.nvim_list_tabpages()) do
  --           tab_num = tab_num + 1
  --         end

  --         if tab_num > 1 then
  --           if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
  --             return true
  --           end
  --         else
  --           return true
  --         end
  --       end,
  --       -- sort_by = function(buffer_a, buffer_b)
  --       --   local mod_a = ((vim.loop.fs_stat(buffer_a.path) or {}).mtime or {}).sec or 0
  --       --   local mod_b = ((vim.loop.fs_stat(buffer_b.path) or {}).mtime or {}).sec or 0
  --       --   return mod_a > mod_b
  --       -- end,
  --     },
  --   },
  -- },
  { "tiagovla/scope.nvim", event = "VeryLazy", opts = {} },
}

