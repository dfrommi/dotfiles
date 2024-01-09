return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function(_, opts)
    	local rust_lsp = require('lsp-zero').build_options('rust_analyzer', {})
		require('rust-tools').setup({
			  server = rust_lsp,
			  dap = {
				adapter = {
				  type = "executable",
				  command = '/opt/homebrew/opt/llvm/bin/lldb-vscode',
				  name = "rt_lldb",
				},
			  },
		})
    end
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {},
  },
}
