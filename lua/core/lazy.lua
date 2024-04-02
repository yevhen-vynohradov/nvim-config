local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.code" },
	{ import = "plugins.editor" },
	{ import = "plugins.tools" },
	{ import = "plugins.vcs" },
	-- { import = "plugins.notes" },
	-- { import = "plugins.ai" },
	{ import = "pde" },
}, {
	defaults = { lazy = true, version = nil },
	install = {
		missing = true,
		colorscheme = { "tokyonight", "monokai-pro", "nightfly" },
	},
	ui = {
		border = "rounded",
	},
	dev = { patterns = jit.os:find "Windows" and {} or { "alpha2phi" } },
	checker = {
		enabled = true,
		notify = true,
	},
	change_detection = {
		notify = true,
	},
	performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },
})

vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })
