return {
  {
    "Zeioth/dooku.nvim",
    enabled = false,
    cmd = { "DookuGenerate", "DookuOpen", "DookuAutoSetup" },
    opts = {},
  },
  {
    "luckasRanarison/nvim-devdocs",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
  }
}