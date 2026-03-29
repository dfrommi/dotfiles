local code = require("my.code")

code.mason("jdtls")
code.mason("java-debug-adapter")
code.mason("java-test")
code.treesitter("java")
code.treesitter("groovy") -- build.gradle files
code.test_adapter(require("neotest-java")({}))

local lombok = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

local style_path = vim.fn.getcwd() .. "/code-style.xml"
local jdtls_settings = {}

if vim.uv.fs_stat(style_path) then
  jdtls_settings = {
    java = { format = { settings = { url = style_path } } },
  }
else
  jdtls_settings = {
    java = { format = { enabled = false } },
  }
end

local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local bundles = {}

local debug_jar = vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
if debug_jar ~= "" then
  table.insert(bundles, debug_jar)
end

local test_jars = vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true, true)
for _, jar in ipairs(test_jars) do
  table.insert(bundles, jar)
end

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

-- nvim-jdtls replaces vim.lsp.enable("jdtls") to avoid two server instances.
-- It provides extended code actions: organize imports, extract variable/constant/method, etc.
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "java",
--   callback = function()
--     local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--     local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name
--
--     -- Find Lombok jar lazily so it works even if Gradle downloads it after Neovim starts
--     local lombok_matches = vim.fn.glob(
--       vim.fn.expand("~") .. "/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/*/*/lombok-*.jar",
--       false,
--       true
--     )
--     local cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls", "-data", workspace_dir }
--     if lombok_matches[1] then
--       table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_matches[1])
--     end
--
--     require("jdtls").start_or_attach({
--       cmd = cmd,
--       root_dir = vim.fs.root(0, { ".git", "build.gradle", "build.gradle.kts" }),
--       on_attach = function(_, bufnr)
--         local function map(mode, lhs, rhs, desc)
--           vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
--         end
--         require("my.keymap").java_bindings(map)
--       end,
--     })
--   end,
-- })
