-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.leader = ","

vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.numberwidth = 8
vim.opt.whichwrap = "b,s"

-- Set or unset cursor row highlight
lvim.keys.normal_mode["nc"] = ":verbose set nocursorline<CR>"
lvim.keys.normal_mode["sc"] = ":verbose set cursorline<CR>"

-- Change the first char to upper case
lvim.keys.normal_mode["<C-u>"] = "<Esc>b~lea"
-- Change the whole word to upper case
--lvim.keys.normal_mode["<C-u>"] = "<Esc>viwUea"

-- Remove tail space
lvim.keys.normal_mode["<leader><space>"] = ":StripTrailingWhitespace<CR>"

lvim.keys.normal_mode["<leader>2"] = ":NvimTreeToggle<CR>"
lvim.keys.normal_mode["<leader>3"] = ":TagbarToggle<CR>"
lvim.keys.normal_mode["<leader>4"] = ":GitGutterDiffOrig<CR>"

lvim.keys.normal_mode["<leader>h"] = ":nohlsearch<CR>"

lvim.keys.normal_mode["J"] = "<C-d>"
lvim.lsp.buffer_mappings.normal_mode['K'] = nil
lvim.keys.normal_mode["K"] = false
lvim.keys.normal_mode["K"] = "<C-u>"

lvim.keys.normal_mode["mh"] = ":split<CR>"
lvim.keys.normal_mode["mv"] = ":vsplit<CR>"
lvim.keys.normal_mode["mt"] = ":terminal<CR>"

-- Move cursor to head or tail of current line
lvim.keys.normal_mode["H"] = "^"
lvim.keys.normal_mode["L"] = "g_"

lvim.keys.normal_mode["gn"] = false
lvim.keys.normal_mode["gp"] = false
lvim.keys.normal_mode["gn"] = ":GitGutterNextHunk<CR>"
lvim.keys.normal_mode["gp"] = ":GitGutterPrevHunk<CR>"

lvim.keys.normal_mode["ff"] = ":Telescope fd<CR>"
lvim.keys.normal_mode["fb"] = ":Telescope buffers<CR>"
lvim.keys.normal_mode["fs"] = ":Telescope live_grep<CR>"

lvim.keys.normal_mode["<leader>n"] = ":set number<CR>"
lvim.keys.normal_mode["<leader>r"] = ":set relativenumber<CR>"
lvim.keys.normal_mode["<leader>a"] = ":set nonumber<CR>:set norelativenumber<CR>"

-- Disable mouse, so copy and paste will be handled by terminal
vim.opt.mouse = ""

-- gd: go to definition
-- gr: go to reference
-- gD: go to declaration
-- gI: go to implementation

-- ChatGPT plugin command
-- ChatGPT
-- ChatGPTActAs
-- ChatGPTCompleteCode
-- ChatGPTEditWithInstructions
-- ChatGPTRun

-- ChatGPT plugin key bindings
-- <Tab> to switch windows
-- <C-c> to close chat window
-- <C-p> toggle session list
-- <C-k> to copy/yank code from last answer
-- <C-h> toogle help window

-- Plugins for colorscheme, golang, python
lvim.plugins = {
        "Mofiqul/dracula.nvim",
        "airblade/vim-gitgutter",
        "preservim/tagbar",
        "axelf4/vim-strip-trailing-whitespace",
        "Darazaki/indent-o-matic",
        {
                "jackMort/ChatGPT.nvim",
                event = "VeryLazy",
                config = function()
                        require("chatgpt").setup({
                                api_key_cmd = "get-secret-key"
                        })
                end,
                dependencies = {
                        "MunifTanjim/nui.nvim",
                        "nvim-lua/plenary.nvim",
                        "folke/trouble.nvim",
                        "nvim-telescope/telescope.nvim"
                }
        },

        -- Plugins for golang and python IDE, copy go-ide.tmp or python-ide.tmp to the bottom of this file
        --"olexsmir/gopher.nvim",
        --"leoluz/nvim-dap-go",
        --"ChristianChiarulli/swenv.nvim",
        --"stevearc/dressing.nvim",
        --"mfussenegger/nvim-dap-python",
        --"nvim-neotest/nvim-nio",
        --"nvim-neotest/neotest",
        --"nvim-neotest/neotest-python",
}

-- Do not use gitgutter key map
vim.g.gitgutter_map_keys = 0

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_b = {
        components.branch,
        components.diff
}
lvim.builtin.lualine.sections.lualine_c = { { "filename", file_status = true, path = 2 } }
lvim.builtin.lualine.sections.lualine_y = {
        components.encoding
}

-- Colorscheme
lvim.colorscheme = "dracula"

------------------------
-- Formatting (GO)
------------------------
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
        { command = "goimports", filetypes = { "go" } },
        { command = "gofumpt",   filetypes = { "go" } },
}

lvim.format_on_save = true
