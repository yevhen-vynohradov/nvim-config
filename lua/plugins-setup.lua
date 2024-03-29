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

require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.qoc" },
	{ import = "plugins.ui" },
	{ import = "plugins.tools" },
	{ import = "plugins.vcs" },
	--[[ { import = "core.utils" }, ]]
}, {
	install = {
		--colorscheme = { "nightfly" },
		colorscheme = { "tokyonight" },
		-- colorscheme = { "monokai-pro" },
	},
	ui = {
		border = "rounded",
	},
	checker = {
		enabled = true,
		notify = true,
	},
	change_detection = {
		notify = true,
	},
})
