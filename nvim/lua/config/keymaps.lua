-- Selective copy/paste from LazyVim's keymapslua
require("config.keymap_fixes")

local Util = require("lazyvim.util")

local k = vim.keymap

-- Move lines
k.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
k.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
k.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
k.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
k.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
k.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Buffer
k.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
k.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
k.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

k.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "[K]eyword help" })

k.set({ "n", "v" }, "<leader>cf", function()
  Util.format({ force = true })
end, { desc = "Format" })

-- quit
-- k.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- diagnostic popup under cursor/line
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
k.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
k.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
k.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
k.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
k.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
k.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
k.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- lazygit popup
k.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
end, { desc = "[G]oto Lazy[g]it" })

-- Terminal
k.set("n", "<c-/>", function()
  Util.terminal(nil, { cwd = Util.root() })
end, { desc = "Terminal" })
k.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
