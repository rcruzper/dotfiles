return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
        require("neo-tree.events").clear_all_events()
        require("neo-tree.sources.manager")._clear_state()
        require("neo-tree.ui.renderer").clean_invalid_neotree_buffers(true)

        collectgarbage("collect")

        require('neo-tree').setup({
            close_if_last_window = true,
            filesystem = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                }
            },
        })

		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}

