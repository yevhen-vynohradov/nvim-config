return {
  {
    "axkirillov/hbac.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      autoclose = true,
      threshold = 10,
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    enabled = false,
    opts = {
      retirementAgeMins = 20,
    },
    event = "VeryLazy",
  },
  {
    	-- buffer remove
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
