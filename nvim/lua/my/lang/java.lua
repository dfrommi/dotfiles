local code = require("my.code")

code.mason("jdtls")
code.mason("java-debug-adapter")
code.mason("java-test")
code.treesitter("java")
code.treesitter("groovy") -- build.gradle files
code.test_adapter(require("neotest-java")({}))

local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local lombok = mason_path .. "/jdtls/lombok.jar"

local style_path = vim.fn.getcwd() .. "/code-style.xml"
local jdtls_settings = { java = { format = { enabled = false } } }
if vim.uv.fs_stat(style_path) then
  jdtls_settings = { java = { format = { settings = { url = style_path } } } }
end

local bundles =
  vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
vim.list_extend(bundles, vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true, true))

code.lsp("jdtls", {
  cmd = {
    "jdtls",
    "--jvm-arg=-javaagent:" .. lombok,
  },
  settings = jdtls_settings,
  init_options = {
    bundles = bundles,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end
  end,
})
