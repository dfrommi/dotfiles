local k = vim.keymap

--k.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>")

-- replace selected text
k.set("x", "<leader>p", [["_dP]])

-- yank into system clipboard
k.set({ "n", "v" }, "<leader>y", [["+y]])
k.set("n", "<leader>Y", [["+Y]])

-- delete without affection default register
k.set({ "n", "v" }, "<leader>d", [["_d]])
