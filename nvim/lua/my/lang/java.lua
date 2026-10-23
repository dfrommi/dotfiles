local file_info = require("my.utils.file_info")
if not file_info.root_has_file("build.gradle", "build.gradle.kts", "settings.gradle", "gradlew") then
  return
end

local code = require("my.code")

code.mason("jdtls")
code.mason("java-debug-adapter")
code.mason("java-test")
code.treesitter("java")
code.treesitter("groovy") -- build.gradle files

local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local lombok = mason_path .. "/jdtls/lombok.jar"

local style_path = vim.fn.getcwd() .. "/code-style.xml"

-- https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
local jdtls_settings = {
  java = {
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "automatic",
    },
    format = {
      enabled = false,
    },
  },
}

if vim.uv.fs_stat(style_path) then
  jdtls_settings.java.format = { settings = { url = style_path } }
end

local extended_capabilites = {
  executeClientCommandSupport = true,
  advancedOrganizeImportsSupport = true,
  classFileContentsSupport = true,
}

local bundles =
  vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
vim.list_extend(bundles, vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true, true))

require("jc").setup({
  keys_prefix = "<leader>c",
})
code.test_adapter(require("jc").neotest_adapter())

code.lsp("jdtls", {
  config = {
    cmd = {
      "jdtls",
      "--jvm-arg=-javaagent:" .. lombok,
    },
    settings = jdtls_settings,
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extended_capabilites,
    },
  },
  on_attach = function(client, bufnr)
    require("my.keymap").java_bindings(bufnr)
  end,
})
