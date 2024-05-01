return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                -- Add additional paths for lua packages
                library = (function()
                  local library = {}
                  if vim.fn.has("mac") > 0 then
                    -- http://www.hammerspoon.org/Spoons/EmmyLua.html
                    -- Add a line `hs.loadSpoon('EmmyLua')` on the top in ~/.hammerspoon/init.lua
                    library[vim.fn.expand("$HOME/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations")] = true
                  end
                  return library
                end)(),
              },
            },
          },
        },
      },
    },
  },
}
