local M = {}

local picker = require("snacks").picker
local flash = require("flash")
local splits = require("smart-splits")
local conform = require("conform")
local mini_ai = require("mini.ai")
local mini_files = require("mini.files")
local cmp = require("my.completion")
local neotest = require("neotest")
local dap = require("dap")
local dapui = require("dapui")
local file_info = require("my.utils.file_info")

local function keymap(mode, key, action, opts)
  local options = type(opts) == "string" and { desc = opts } or opts
  vim.keymap.set(mode, key, action, options)
end

-- optional action. Keypress propagated if action not returning true-ish value
local keymap_opt = function(mode, key, action, description)
  keymap(mode, key, function()
    return action() and "" or key
  end, { desc = description, expr = true })
end

--
-- CORE
--
keymap("x", ">", ">gv", "Indent and reselect")
keymap("x", "<", "<gv", "Unindent and reselect")

-- keymap("n", "U", "<C-r>", "Redo [<C-r>]")
keymap("x", "J", ":m '>+1<CR>gv=gv", "Move selection down")
keymap("x", "K", ":m '<-2<CR>gv=gv", "Move selection up")

keymap("x", "p", [["_dP]], "Paste without yanking")
-- keymap({ "n", "v" }, "<leader>d", [["_d]], "Delete without yanking") -- freed for debug prefix

keymap({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
keymap("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")
keymap({ "n", "x" }, "<leader>p", [["+p]], "Paste from system clipboard")
keymap({ "n", "x" }, "<leader>P", [["+P]], "Paste before from system clipboard")

keymap("n", "<leader>cyf", file_info.yank_relative_file_path, "Yank file path (project relative)")
keymap("x", "<leader>cyf", file_info.yank_relative_file_path_with_range, "Yank file path with range (project relative)")
keymap("n", "<leader>cyF", file_info.yank_relative_dir_path, "Yank directory path (project relative)")

--
-- ITEM PICKER
--

--
-- FIND
--
keymap("n", "<leader>ff", picker.files, "Find Files")
keymap("n", "<leader>fF", function()
  picker.files({ dirs = { vim.fn.expand("%:h") } })
end, "Find Files (buffer dir)")
keymap("n", "<leader>fg", picker.grep, "Find in Files")
keymap("n", "<leader>fG", function()
  picker.grep({ dirs = { vim.fn.expand("%:h") } })
end, "Find in Files (buffer dir)")
keymap("n", "<leader>fb", picker.buffers, "Find Buffers")
keymap("n", "<leader>fB", picker.grep_buffers, "Find in Buffers")
--vim.keymap.set("n", "<leader>fr", picker.recent, { desc = "Recent" })
keymap("n", "<leader>fh", picker.help, "Help Pages")
keymap("n", "<leader>fk", picker.keymaps, "Keymaps")
keymap("n", "<leader>fm", picker.marks, "Marks")
keymap("n", "<leader>fs", picker.lsp_workspace_symbols, "LSP Workspace Symbols")
keymap({ "n", "x" }, "<leader>fw", picker.grep_word, "Visual selection or word")

keymap("n", "<leader>fe", function()
  mini_files.open(vim.api.nvim_buf_get_name(0))
end, "File Explorer (buffer)")
keymap("n", "<leader>fE", mini_files.open, "File Explorer (root)")

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
keymap("n", "gO", function()
  picker.lsp_symbols()
end, "LSP Symbols")

--
-- SCROLLING
--
keymap("n", "<C-d>", "<C-d>zz", "Scroll down and center")
keymap("n", "<C-u>", "<C-u>zz", "Scroll up and center")

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
-- Inline completion: thumb keys right hand
keymap_opt("i", "<S-CR>", cmp.inline.accept, "Inline completion accept")
keymap_opt("i", "<M-BS>", cmp.inline.accept_interactive, "Inline completion interactive")
keymap_opt("i", "<M-DEL>", cmp.inline.next, "Inline completion next")

--keymap_opt("i", "<Tab>", cmp.pum.accept, "Accept completion")
keymap_opt("i", "<S-Tab>", cmp.pum.show_or_accept, "LSP completion show/accept")
keymap_opt("i", "<C-e>", cmp.pum.dismiss, "Dismiss completion")
keymap_opt("i", "<CR>", cmp.pum_accept_if_selected, "Confirm selected completion")

--partial completion of suggestions
keymap("n", "<leader>ak", cmp.start_interactive, "AI suggestion keep")
keymap("x", "<CR>", cmp.apply_interactive, "Confirm AI suggestion keep")
keymap("v", "<Tab>", "w", "Select next word") -- for convenient tab tab tab to expand selection in AI suggest
keymap("v", "<S-Tab>", "b", "Select next word") -- for convenient tab tab tab to expand selection in AI suggest

--
-- TESTING
--
keymap("n", "<leader>tt", function()
  neotest.run.run()
end, "Run nearest test")
keymap("n", "<leader>tT", function()
  neotest.run.run(vim.fn.expand("%"))
end, "Run file tests")
keymap("n", "<leader>tl", function()
  neotest.run.run_last()
end, "Run last test")
keymap("n", "<leader>ts", function()
  neotest.summary.toggle()
end, "Toggle test summary")
keymap("n", "<leader>to", function()
  neotest.output.open({ enter = true, auto_close = true })
end, "Show test output")
keymap("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, "Toggle test output panel")
keymap("n", "<leader>tS", function()
  neotest.run.stop()
end, "Stop running tests")
keymap("n", "<leader>td", function()
  neotest.run.run({ strategy = "dap" })
end, "Debug nearest test")
keymap("n", "<leader>tD", function()
  neotest.run.run(vim.fn.expand("%"), { strategy = "dap" })
end, "Debug file tests")

--
-- DEBUGGING
--
keymap("n", "<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
keymap("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Conditional breakpoint")
keymap("n", "<leader>dc", dap.continue, "Continue / Start")
keymap("n", "<leader>ds", dap.step_over, "Step over")
keymap("n", "<leader>di", dap.step_into, "Step into")
keymap("n", "<leader>do", dap.step_out, "Step out")
keymap("n", "<leader>dq", dap.terminate, "Terminate")
keymap("n", "<leader>du", dapui.toggle, "Toggle DAP UI")
keymap({ "n", "x" }, "<leader>de", function()
  dapui.eval(nil, { enter = true })
end, "Eval expression")

M.mini_surround_mappings = {
  add = "gsa", -- Add surrounding
  delete = "gsd", -- Delete surrounding
  find = "gsf", -- Find surrounding
  find_left = "gsF", -- Find surrounding (to the left)
  highlight = "gsh", -- Highlight surrounding
  replace = "gsr", -- Replace surrounding
  update_n_lines = "gsn", -- Update `n_lines` for the highlighted surrounding
}

M.mini_ai_mappings = {
  around_next = "aN",
  inside_next = "iN",
  around_last = "aL",
  inside_last = "iL",
}

M.mini_ai_textobjects = {
  -- rename to math custom layout better
  ["r"] = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
  ["l"] = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },

  -- built-in text objects:
  --   f - function call
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
  e = { -- Word with case (parts of camelCase, snake_case, etc.)
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

function M.java_bindings(map)
  local jdtls = require("jdtls")
  map("n", "<leader>ji", jdtls.organize_imports, "Java: Organize imports")
  map("n", "<leader>jev", jdtls.extract_variable, "Java: Extract variable")
  map("x", "<leader>jev", function() jdtls.extract_variable(true) end, "Java: Extract variable")
  map("n", "<leader>jec", jdtls.extract_constant, "Java: Extract constant")
  map("x", "<leader>jec", function() jdtls.extract_constant(true) end, "Java: Extract constant")
  map("x", "<leader>jem", function() jdtls.extract_method(true) end, "Java: Extract method")
  map("n", "<leader>dd", function() require("dap").continue() end, "Debug (Java)")
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

  map("n", "<leader>dd", rlsp("debuggables"), "Debug (Rust)")

  -- map("n", "<leader>rr",   rlsp("runnables"),             "Rust: Runnables")
  -- map("n", "<leader>rt",   rlsp("testables"),             "Rust: Testables")
end

return M
