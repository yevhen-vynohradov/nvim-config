local M = {}

local pickers = require("telescope.pickers")
local Path = require("plenary.path")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local os_sep = Path.path.sep
local scan = require("plenary.scandir")

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
  ---@type nil|string[]
  directories = nil,
}

local function run_live_grep(current_input)
  require("telescope.builtin").live_grep {
    additional_args = live_grep_filters.extension and function()
      return { "-g", "*." .. live_grep_filters.extension }
    end,
    search_dirs = live_grep_filters.directories,
    -- default_text = current_input,
  }
end

function M.git_diff_picker(opts)
  opts = opts or require("telescope.themes").get_dropdown {}
  local list = vim.fn.systemlist "git diff --name-only"
  pickers.new(opts,
    { prompt_title = "Git Diff Files", finder = finders.new_table { results = list }, sorter = conf.generic_sorter(opts) })
      :find()
end

M.actions = transform_mod({

  set_extension = function(prompt_bufnr)
    local current_input = action_state.get_current_line()
    vim.ui.input({ prompt = "*." }, function(input)
      if input == nil then
        return
      end
      live_grep_filters.extension = input
      actions.close(prompt_bufnr)
      run_live_grep(current_input)
    end)
  end,

  set_folders = function(prompt_bufnr)
    local current_input = action_state.get_current_line()
    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
      hidden = true,
      only_dirs = true,
      respect_gitignore = true,
      on_insert = function(entry)
        table.insert(data, entry .. os_sep)
      end,
    })
    table.insert(data, 1, "." .. os_sep)
    actions.close(prompt_bufnr)
    pickers
        .new({}, {
          prompt_title = "Folders for Live Grep",
          finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file {} },
          previewer = conf.file_previewer {},
          sorter = conf.file_sorter {},
          attach_mappings = function(bufnr)
            action_set.select:replace(function()
              local current_picker = action_state.get_current_picker(bufnr)

              local dirs = {}
              local selections = current_picker:get_multi_selection()
              if vim.tbl_isempty(selections) then
                table.insert(dirs, action_state.get_selected_entry().value)
              else
                for _, selection in ipairs(selections) do
                  table.insert(dirs, selection.value)
                end
              end
              live_grep_filters.directories = dirs
              actions.close(bufnr)
              run_live_grep(current_input)
            end)
            return true
          end,
        })
        :find()
  end,
})

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "cljoly/telescope-repo.nvim",
      "lpoto/telescope-docker.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "benfowler/telescope-luasnip.nvim",
      "olacin/telescope-cc.nvim",
      "tsakirist/telescope-lazy.nvim",
      "jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "ahmedkhalf/project.nvim",
      "kkharji/sqlite.lua",
      "aaronhallaert/advanced-git-search.nvim",
      "tiagovla/scope.nvim",
      {
        "ecthelionvi/NeoComposer.nvim",
        enabled = false,
      },
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      { "<leader>fd", "<Cmd>Telescope docker<CR>", desc = "Docker" },
      { "<leader><space>", require("utils").find_files,                                                                                     desc = "Find Files" },
      { "<leader>ff",      require("utils").telescope("files"),                                                                             desc = "Find Files (Root Dir)" },
      { "<leader>fF",      require("utils").telescope("files", { cwd = false }),                                                            desc = "Find Files (Cwd)" },
      { "<leader>gf",      M.git_diff_picker,                                                                                               desc = "Diff Files" },
      { "<leader>fo",      "<cmd>Telescope frecency theme=dropdown previewer=false<cr>",                                                    desc = "Recent" },
      { "<leader>fb",      "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>",                                           desc = "Buffers" },
      { "<leader>fm",      "<cmd>Telescope marks<cr>",                                                                                      desc = "Marks" },
      { "<leader>fc",      "<cmd>cd %:p:h<cr>",                                                                                             desc = "Change WorkDir" },
      { "<leader>fg",      function() require("telescope").extensions.live_grep_args.live_grep_args() end,                                  desc = "Live Grep", },
      { "<leader>fr",      "<cmd>Telescope file_browser<cr>",                                                                               desc = "Browser" },
      { "<leader>fz",      "<cmd>Telescope zoxide list<cr>",                                                                                desc = "Recent Folders" },
      { "<leader>gc",      "<cmd>Telescope conventional_commits<cr>",                                                                       desc = "Conventional Commits" },
      { "<leader>zs",      "<cmd>Telescope lazy<cr>",                                                                                       desc = "Search Plugins" },
      { "<leader>ps",      "<cmd>Telescope repo list<cr>",                                                                                  desc = "Search" },
      { "<leader>hs",      "<cmd>Telescope help_tags<cr>",                                                                                  desc = "Search" },
      { "<leader>pp",      function() require("telescope").extensions.project.project { display_type = "minimal" } end,                     desc = "List", },
      { "<leader>sw",      require("utils").telescope("live_grep"),                                                                         desc = "Grep (Root Dir)" },
      { "<leader>sW",      require("utils").telescope("live_grep", { cwd = false }),                                                        desc = "Grep (Cwd)" },
      { "<leader>ss",      "<cmd>Telescope luasnip<cr>",                                                                                    desc = "Snippets" },
      { "<leader>sb",      function() require("telescope.builtin").current_buffer_fuzzy_find() end,                                         desc = "Buffer", },
      { "<leader>vo",      "<cmd>Telescope aerial<cr>",                                                                                     desc = "Code Outline" },
      { "<leader>zc",      function() require("telescope.builtin").colorscheme({ enable_preview = true }) end,                              desc = "Colorscheme", },
      { "<leader>su",      function() require("telescope.builtin").live_grep({ search_dirs = { vim.fs.dirname(vim.fn.expand("%")) } }) end, desc = "Grep (Current File Path)" },
    },
    config = function(_, _)
      local telescope = require("telescope")
      local icons = require("core.icons")
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")
      local transform_mod = require("telescope.actions.mt").transform_mod
      local custom_pickers = M
      local custom_actions = transform_mod {

        -- File path
        file_path = function(prompt_bufnr)
          -- Get selected entry and the file full path
          local content = require("telescope.actions.state").get_selected_entry()
          local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

          -- Yank the path to unnamed and clipboard registers
          vim.fn.setreg('"', full_path)
          vim.fn.setreg("+", full_path)

          -- Close the popup
          vim.notify "File path is yanked "
          require("telescope.actions").close(prompt_bufnr)
        end,

        -- Change directory
        cwd = function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          local dir = vim.fn.fnamemodify(selection.path, ":p:h")
          require("telescope.actions").close(prompt_bufnr)
          -- Depending on what you want put `cd`, `lcd`, `tcd`
          vim.cmd(string.format("silent lcd %s", dir))
        end,

        -- VisiData
        visidata = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end
          local file_path = ""
          if content.filename then
            file_path = content.filename
          elseif content.value then
            if content.cwd then
              file_path = content.cwd
            end
            file_path = file_path .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open the file with VisiData
          local utils = require("utils")
          utils.open_term("vd " .. file_path, { direction = "float" })
        end,

        -- File browser
        file_browser = function(prompt_bufnr)
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local file_dir = ""
          if content.filename then
            file_dir = vim.fs.dirname(content.filename)
          elseif content.value then
            if content.cwd then
              file_dir = content.cwd
            end
            file_dir = file_dir .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open file browser
          -- vim.cmd("Telescope file_browser select_buffer=true path=" .. vim.fs.dirname(full_path))
          require("telescope").extensions.file_browser.file_browser { select_buffer = true, path = file_dir }
        end,

        -- Toggleterm
        toggle_term = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local file_dir = ""
          if content.filename then
            file_dir = vim.fs.dirname(content.filename)
          elseif content.value then
            if content.cwd then
              file_dir = content.cwd
            end
            file_dir = file_dir .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open terminal
          local utils = require("utils")
          utils.open_term(nil, { direction = "float", dir = file_dir })
        end,
      }

      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["?"] = actions_layout.toggle_preview,
          ["<C-s>"] = custom_actions.visidata,
          ["<A-f>"] = custom_actions.file_browser,
          ["<C-z>"] = custom_actions.toggle_term,
        },
        n = {
          ["s"] = custom_actions.visidata,
          ["z"] = custom_actions.toggle_term,
          ["<A-f>"] = custom_actions.file_browser,
          ["q"] = require("telescope.actions").close,
          ["cd"] = custom_actions.cwd,
        },
      }

      local opts = {
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          mappings = mappings,
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          path_display = { "truncate" },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
          live_grep = {
            mappings = {
              i = {
                ["<c-f>"] = custom_pickers.actions.set_extension,
                ["<c-l>"] = custom_pickers.actions.set_folders,
              },
            },
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
            previewer = false,
            hijack_netrw = false,
            mappings = mappings,
          },
          project = {
            hidden_files = false,
            theme = "dropdown",
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
      telescope.load_extension("projects")
      telescope.load_extension("aerial")
      telescope.load_extension("dap")
      telescope.load_extension("frecency")
      telescope.load_extension("luasnip")
      telescope.load_extension("conventional_commits")
      telescope.load_extension("lazy")
      telescope.load_extension("noice")
      telescope.load_extension("notify")
      telescope.load_extension("zoxide")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("scope")
      telescope.load_extension("docker")

      -- Highlights
      local fg_bg = require("utils").fg_bg
      local colors = require("core.colors")
      fg_bg("TelescopePreviewTitle", colors.black, colors.green)
      fg_bg("TelescopePromptTitle", colors.black, colors.red)
      fg_bg("TelescopeResultsTitle", colors.darker_black, colors.blue)
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  }
}
