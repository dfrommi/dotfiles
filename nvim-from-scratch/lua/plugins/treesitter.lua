return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
	  'nvim-treesitter/nvim-treesitter-textobjects',
	  'nvim-treesitter/nvim-treesitter-context',
	},
	build = ':TSUpdate',
	lazy = false, -- other plugins like Dap virtual text can't get parser otherwise
	config = function()
		require("nvim-treesitter.configs").setup {
		  ensure_installed = {
			  "bash",
			  "diff",
			  "dockerfile",
			  "fish",
			  "html",
			  "java",
			  "json",
			  "kotlin",
			  "lua",
			  "luadoc",
			  "markdown",
			  "markdown_inline",
			  "python",
			  "rust",
			  "toml",
			  "vim",
			  "vimdoc",
			  "yaml",
		  },
		  indent = {
			enable = true,
		  },
		  highlight = { 
			  enable = true, 
		  },
	      incremental_selection = {
			  enable = true,
			  keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			  },
		  },
		  textobjects = {
		    move = {
				enable = true,
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		    },
		  },
	    }
	end
}

