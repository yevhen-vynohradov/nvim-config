return {
  {
    -- Heuristic buffer auto-close
    -- Automagically close the unedited buffers in your bufferlist
    -- when it becomes too long. The "edited" buffers remain untouched.
    -- For a buffer to be considered edited it is enough to enter insert
    -- mode once or modify it in any way.

    -- https://github.com/axkirillov/hbac.nvim

    "axkirillov/hbac.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      autoclose = true,
      threshold = 10,
    },
    -- config = function()
    --   require('telescope').load_extension('hbac')
    -- end
  },
  {
    -- Send buffers into early retirement by automatically
    -- closing them after x minutes of inactivity.

    -- https://github.com/chrisgrieser/nvim-early-retirement

    "chrisgrieser/nvim-early-retirement",
    enabled = false,
    opts = {
      retirementAgeMins = 20,
    },
    event = "VeryLazy",
  },
  {
    -- Buffer removing (unshow, delete, wipeout), which saves window layout

    -- https://github.com/echasnovski/mini.bufremove

    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>br", "<cmd>e!<cr>",                        desc = "Reload Buffer" },
      { "<leader>bc", "<cmd>close<cr>",                     desc = "Close Buffer" },
      { "<leader>bd", require("utils").delete_buffer,       desc = "Delete Buffer" },
      { "<leader>bD", require("utils").force_delete_buffer, desc = "Delete Buffer (Force)" },
    },
  },
}
