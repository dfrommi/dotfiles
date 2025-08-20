local M = {}

local picker = require("snacks").picker
local flash = require("flash")
local splits = require("smart-splits")
local conform = require("conform")
local mini_ai = require("mini.ai")
local cmp = require("my.completion")
local assistant = require("my.assistant")

local function keymap(mode, key, action, opts)
  local options = type(opts) == "string" and { desc = opts } or opts
  vim.keymap.set(mode, key, action, options)
end

--
-- CORE
--
-- keymap("n", "U", "<C-r>", "Redo [<C-r>]")
keymap("x", "J", ":m '>+1<CR>gv=gv", "Move selection down")
keymap("x", "K", ":m '<-2<CR>gv=gv", "Move selection up")

keymap("x", "p", [["_dP]], "Paste without yanking")
keymap({ "n", "v" }, "<leader>d", [["_d]], "Delete without yanking")

keymap({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
keymap("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")
keymap({ "n", "x" }, "<leader>p", [["+p]], "Paste from system clipboard")
keymap({ "n", "x" }, "<leader>P", [["+P]], "Paste before from system clipboard")

--
-- ITEM PICKER
--

--
-- FIND
--
keymap("n", "<leader>ff", picker.files, "Find Files")
-- vim.keymap.set("n", "<leader>fg", picker.git_files, { desc = "Find Git Files" })
keymap("n", "<leader>fF", picker.grep, "Find in Files")
keymap("n", "<leader>fb", picker.buffers, "Find Buffers")
keymap("n", "<leader>fB", picker.grep_buffers, "Find in Buffers")
--vim.keymap.set("n", "<leader>fr", picker.recent, { desc = "Recent" })
keymap("n", "<leader>fe", picker.explorer, "File Explorer")
keymap("n", "<leader>fh", picker.help, "Help Pages")
keymap("n", "<leader>fk", picker.keymaps, "Keymaps")
keymap("n", "<leader>fs", picker.lsp_workspace_symbols, "LSP Workspace Symbols")
keymap({ "n", "x" }, "<leader>*", picker.grep_word, "Visual selection or word")

--
-- CODE EDITING
--
keymap("n", "<leader><enter>", vim.lsp.buf.code_action, "Code Actions")
-- keymap("i", "<C-space>", vim.lsp.buf.completion, "Completion")
keymap("n", "grf", conform.format, "Format buffer") -- maybe not needed due to auto formatting on save
keymap("n", "grN", Snacks.rename.rename_file, "Rename File")
keymap("n", "grd", vim.lsp.buf.definition, "Go to Definition")
keymap("n", "grD", vim.lsp.buf.declaration, "Go to Declaration")
keymap("n", "grc", vim.lsp.buf.incoming_calls, "Incoming Calls")
keymap("n", "grC", vim.lsp.buf.outgoing_calls, "Outgoing Calls")
-- no need to go via location list for arbitrary collection of symbols. Always pick one, never bulk-operate
keymap("n", "gO", picker.lsp_symbols, "LSP Symbols")

--
-- JUMPING
--

-- Colemak adjustment for jumplist and avoind conflict with window navigation
keymap({ "n", "v" }, "<C-h>", "<C-o>", "Jump back (Colemak) [<C-o>]")
keymap({ "n", "v" }, "<C-l>", "<C-i>", "Jump forward (Colemak) [<C-i>]")

keymap({ "n", "x", "o" }, "s", flash.jump, "Flash")
keymap({ "n", "x", "o" }, "S", flash.treesitter, "Flash Treesitter")
keymap("o", "r", flash.remote, "Remote Flash")
keymap({ "o", "x" }, "R", flash.treesitter_search, "Treesitter Search")

--
-- WINDOW MANAGEMENT
--
keymap("n", "<leader><space>", "<C-^>", "Toggle Buffer [<C-^>]")
-- CTRL+W S/V to create splits
keymap("n", "<C-n>", splits.move_cursor_left, "Go to Left Window [<C-w>h]")
keymap("n", "<C-e>", splits.move_cursor_down, "Go to Bottom Window [<C-w>j]")
keymap("n", "<C-i>", splits.move_cursor_up, "Go to Top Window [<C-w>k]")
keymap("n", "<C-o>", splits.move_cursor_right, "Go to Right Window [<C-w>l]")

--
-- COMPLETION
--
local cmp_keymap = function(mode, key, pum_action, cop_action, description)
  local action = cmp.action(pum_action, cop_action, key)
  keymap(mode, key, action, { desc = description, expr = true })
end

keymap("i", "<S-CR>", cmp.cycle("<S-CR>"), { desc = "Cycle completion items", expr = true })
cmp_keymap("i", "<Tab>", cmp.pum.confirm_selected_or_first, cmp.cop.confirm_all, "Accept completion")
cmp_keymap("i", "<S-Tab>", nil, cmp.cop.confirm_all_and_start_partial_accept, "AI partial accept")
cmp_keymap("i", "<C-e>", cmp.pum.dismiss, cmp.cop.dismiss, "Dismiss completion")
cmp_keymap("i", "<CR>", cmp.pum.confirm_if_selected, nil, "Confirm selected completion")

--partial completion of suggestions
keymap("n", "<leader>ak", cmp.cop.start_partial_accept, "AI suggestion keep")
keymap("x", "<CR>", cmp.cop.confirm_selection, "Confirm AI suggestion keep")
keymap("v", "<Tab>", "w", "Select next word") -- for convenient tab tab tab to expand selection in AI suggest
keymap("v", "<S-Tab>", "b", "Select next word") -- for convenient tab tab tab to expand selection in AI suggest

--
-- AI
--
keymap("n", "<leader>aA", assistant.ask(), "Ask Assistant")
keymap("n", "<leader>aa", assistant.ask("@cursor: "), "Ask Assistant at cursor")
keymap("v", "<leader>aa", assistant.ask("@selection: "), "Ask Assistant for selection")
keymap({ "n", "v" }, "<leader>ap", assistant.select_prompt, "Select prompt")
keymap("n", "<leader>af", assistant.activate, "Focus AI Assistant")
keymap("n", "<leader>as", assistant.split_bottom, "AI Assistant split bottom")
keymap("n", "<leader>av", assistant.split_right, "AI Assistant split right")
keymap("n", "<leader>au", assistant.unsplit, "AI Assistant unsplit")

M.mini_surround_mappings = {
  add = "gsa", -- Add surrounding
  delete = "gsd", -- Delete surrounding
  find = "gsf", -- Find surrounding
  find_left = "gsF", -- Find surrounding (to the left)
  highlight = "gsh", -- Highlight surrounding
  replace = "gsr", -- Replace surrounding
  update_n_lines = "gsn", -- Update `n_lines` for the highlighted surrounding
}

M.mini_textobjects = {
  -- built-in text objects:
  --   f - function
  --   t - tag
  --   a - argument
  o = mini_ai.gen_spec.treesitter({ -- code block
    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
  }),
  F = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function (not working in Rust?)
  c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
  s = mini_ai.gen_spec.treesitter({ a = "@statement.outer", i = "@statement.outer" }), -- statement
  C = mini_ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }), -- comment
  e = { -- Word with case (parts of camilCase, snake_case, etc.)
    { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
    "^().*()$",
  },
}

function M.git_signs_bindings(map, gs)
  map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
  map("n", "<leader>gd", gs.preview_hunk_inline, "Diff Hunk Inline")
  -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

function M.rust_bindings(map, rlsp)
  map("n", "J", rlsp("joinLines"), "Join lines")
  -- map("n", "K", rlsp({ "hover", "actions" }), "Hover actions")

  --TODO fix selection after move
  map("x", "J", rlsp({ "moveItem", "down" }), "Move selection down")
  map("x", "K", rlsp({ "moveItem", "up" }), "Move selection up")

  -- not working map("v", "K", rlsp("hover range"), "Hover actions")
  -- map("n", "<leader>ca", rlsp("codeAction"), "Code actions")
  -- TODO not existing, but optimize import would be nice
  -- map("n", "<leader>cA", rlsp("codeAction source"), "Rust: Source actions")

  map("n", "gu", rlsp("parentModule"), "Parent module (Go Up)")

  map("n", "<leader>cd", rlsp("renderDiagnostic"), "Render Diagnostic")
  map("n", "<leader>ce", rlsp("explainError"), "Explain Error")
  map("n", "<leader>cm", rlsp("expandMacro"), "Expand Macro")

  -- map("n", "<leader>rr",   rlsp("runnables"),             "Rust: Runnables")
  -- map("n", "<leader>rt",   rlsp("testables"),             "Rust: Testables")
end

return M
