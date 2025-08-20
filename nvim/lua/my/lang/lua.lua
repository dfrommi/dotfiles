local code = require("my.code")

code.mason("lua-language-server") -- Lua LSP
code.mason("stylua") -- Lua formatter
code.lsp("lua_ls")
code.treesitter("lua")
code.conform("lua", "stylua")
