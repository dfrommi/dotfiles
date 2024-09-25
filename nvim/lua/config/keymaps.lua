local k = vim.keymap

-- modes:
--   v = only in character based visual mode
--   x = any visual mode

-- replace selected text without affecting default register
k.set("x", "p", [["_dP]])

-- delete without affecting default register
k.set({ "n", "v" }, "<leader>d", [["_d]])

-- yank and paste with system clipboard
k.set({ "n", "v" }, "<leader>y", [["+y]])
k.set("n", "<leader>Y", [["+Y]])

k.set({ "n", "x" }, "<leader>p", [["+p]])
k.set({ "n", "x" }, "<leader>P", [["+P]])

-- Better for Colemak
k.set("n", "<C-i>", "<C-o>", { noremap = true })
k.set("n", "<C-o>", "<C-i>", { noremap = true })
