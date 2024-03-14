return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            {
                'nvim-telescope/telescope-fzf-native.nvim', 
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
            }
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = {
                        "node_modules",
                        ".git",
                        ".yarn.lock",
                    },
                    hidden = true,
                },
            })

            vim.keymap.set('n', '<leader>?', require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
            vim.keymap.set('n', '<leader>fb', require("telescope.builtin").buffers, { desc = "[F]ind Open [B]uffers" })
            vim.keymap.set('n', '<leader>ff', require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
            vim.keymap.set('n', '<leader>fh', require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
            vim.keymap.set('n', '<leader>fg', require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })

            pcall(require("telescope").load_extension, "fzf")
        end,
    },
}

