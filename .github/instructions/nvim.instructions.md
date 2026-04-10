---
applyTo: nvim/**
---
# Neovim Guidelines

## Project Structure & Module Organization

`init.lua` bootstraps Neovim, registers plugins via `vim.pack.add`, then loads modules from `lua/my`. Core defaults live in `options.lua`, `core.lua`, and `keymap.lua`; feature layers such as `code.lua` configure tooling. Completion sources live in `lua/my/completion/`, language packs in `lua/my/lang/`, and shared helpers in `lua/my/utils/`. Add new modules under `lua/my/` and require them from `init.lua` beside related features to keep load order predictable.

### Load order matters

`init.lua` loads in this order: `options` → `core` → `completion` → `lang/*` → feature modules (e.g. `dap`) → `code.setup()` → `keymap`. Language packs register their needs (Mason tools, treesitter parsers, LSP configs, test adapters) via `code.lua` helper functions (`code.mason()`, `code.lsp()`, `code.treesitter()`, `code.conform()`, `code.test_adapter()`), then `code.setup()` applies everything at once. New feature modules that depend on lang registrations go between lang files and `code.setup()`.

### Adding a new cross-cutting feature

When a feature spans multiple languages (like testing or debugging), create a dedicated `lua/my/<feature>.lua` for common setup, then put language-specific wiring in the respective `lua/my/lang/<lang>.lua` files. Use `code.mason()` from lang files to register any required tools. Do **not** add new extension functions to `code.lua` unless there is a genuine "collect then apply" pattern — if each language plugin handles its own adapter/config, a central registry is unnecessary.

### Keymaps

All keymaps are centrally defined in `lua/my/keymap.lua`. Language-specific keymaps are exported as functions (e.g. `M.java_bindings(map)`, `M.rust_bindings(map, rlsp)`) and called from the language file's `on_attach` callback with a buffer-scoped `map` helper. Global keymaps go directly in the file body, grouped by concern with comment headers. When adding a new feature, add a new section (e.g. `-- DEBUGGING`) after the existing ones.

## Package Management

Plugins are managed via `vim.pack.add` in `init.lua` and tracked in `nvim-pack-lock.json`. **Never edit `nvim-pack-lock.json` directly.** To remove a plugin, run `:lua vim.pack.del({"the-package-name"})` inside Neovim — this updates the lock file correctly.

## Commit & Pull Request Guidelines

Follow the existing pattern `[scope] Summary` (scope examples: `nvim`, `fish`, `git`) and keep messages imperative. Prefer focused commits. Pull requests should outline motivation, highlight notable config updates, list manual verification (health check, language smoke tests), and attach screenshots when UI changes such as lualine or colorschemes are involved. Link related issues or TODOs and flag follow-up work.

## Agent-Specific Tips

When extending `lua/my/assistant.lua`, reuse helpers from `lua/my/utils/wezterm.lua` so pane operations stay uniform. If the target WezTerm pane is renamed, update `find_codex()` and document the expectation. Send prompts via `wezterm.send_text` instead of raw escape codes and keep clipboard fallbacks intact for terminals without WezTerm automation.

