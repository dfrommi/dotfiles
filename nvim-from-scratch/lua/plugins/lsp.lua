return {
  {
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	dependencies = {
			-- LSP
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

			-- Completion
            "hrsh7th/nvim-cmp",
            --"hrsh7th/cmp-buffer",  -- word from buffer
            --"hrsh7th/cmp-path", -- file system path
            "hrsh7th/cmp-nvim-lsp",
            --"hrsh7th/cmp-nvim-lua",

			-- snippets
			--"saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            rafamadriz--"rafamadriz/friendly-snippets",

			-- Format on save
            --{ "lukas-reineke/lsp-format.nvim", config = true },
	},
	config = function()
		local lsp_zero = require('lsp-zero')

		lsp_zero.on_attach(function(client, bufnr)
		   -- see :help lsp-zero-keybindings to learn the available actions
		   lsp_zero.default_keymaps({buffer = bufnr})
		end)

		require('mason').setup({})
		require('mason-lspconfig').setup({
		  ensure_installed = { "lua_ls", "rust_analyzer" },
		  handlers = {
			lsp_zero.default_setup,
		  },
		})
	end
  },
}
