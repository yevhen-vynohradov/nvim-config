return {
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = {
      autoclose = true,
      threshold = 10,
    },
    enabled = true,
  },
  -- {
  --   "chrisgrieser/nvim-early-retirement",
  --   opts = {
  --     retirementAgeMins = 20,
  --   },
  --   event = "VeryLazy",
  --   enabled = false,
  -- },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>br", "<cmd>e!<cr>", desc = "Reload Buffer" },
      { "<leader>bc", "<cmd>close<cr>", desc = "Close Buffer" },
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
}