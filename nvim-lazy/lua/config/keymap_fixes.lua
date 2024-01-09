--
-- Fixes of built-in mappings
--

-- Selective copy/paste from LazyVim's keymapslua

local k = vim.keymap

-- better j/k handling with wrapped lines
-- goes to next screen-line (as opposed to file-line) unless used with number-prefix.
k.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
k.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
k.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
k.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search with <esc>
k.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Consistent direction of n/N
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
k.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
k.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
k.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
k.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
k.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
k.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- preserve selection on indent in visual mode
k.set("v", "<", "<gv")
k.set("v", ">", ">gv")
