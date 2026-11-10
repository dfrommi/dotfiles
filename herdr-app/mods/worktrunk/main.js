// Worktrunk dialog: list local and remote branches, then open a selected
// branch in a worktree or create a worktree for a new branch.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input, Scrollbar } from "gpui-base";
import { run, props, closeOverlay, theme, spaces, panes, exec } from "herdr";

const pathOf = (path) => (path ?? "").replace(/\\/g, "/");

// Where a space is now: its first terminal's live folder, else where it was made.
function place(s, all = panes()) {
  if (!s) return null;
  const tabs = new Set((s.tabs ?? []).map((c) => c.id));
  return all.find((p) => tabs.has(p.tab) && p.cwd)?.cwd || s.folder || null;
}

// Every checkout of a repository (`git worktree list`), with the main one first.
async function checkouts(repo, on) {
  const result = await git(repo.main, ["worktree", "list", "--porcelain"], on);
  if (!result.ok) return [];
  const out = [];
  for (const block of result.out.split(/\n\n+/)) {
    const lines = block.split("\n");
    const path = lines.find((line) => line.startsWith("worktree "))?.slice(9);
    if (!path || lines.some((line) => line === "bare" || line.startsWith("prunable"))) continue;
    const branch = lines.find((line) => line.startsWith("branch "))?.slice(7).replace(/^refs\/heads\//, "") ?? null;
    out.push({ path: pathOf(path), branch, main: out.length === 0 });
  }
  return out;
}

// Local branches and remote branches, with the remote name omitted from the label.
async function branches(repo, on, checkoutList) {
  const result = await git(repo.main, ["for-each-ref", "--format=%(refname)\t%(refname:short)", "refs/heads", "refs/remotes"], on);
  if (!result.ok) return [];
  const checkedOut = new Map(checkoutList.filter((checkout) => checkout.branch).map((checkout) => [checkout.branch, checkout]));
  const local = [];
  const remote = [];
  for (const line of result.out.split("\n").filter(Boolean)) {
    const [ref, short] = line.split("\t");
    if (ref.startsWith("refs/heads/")) {
      local.push({ name: short, remote: false, checkout: checkedOut.get(short) });
      continue;
    }
    if (!ref.startsWith("refs/remotes/") || ref.endsWith("/HEAD")) continue;
    const name = short.replace(/^[^/]+\//, "");
    if (!name || name === "HEAD" || name.endsWith("/HEAD")) continue;
    remote.push({ name, remote: true, checkout: checkedOut.get(name) });
  }
  const localNames = new Set(local.map((branch) => branch.name));
  return [...local, ...remote.filter((branch) => !localNames.has(branch.name))]
    .sort((a, b) => a.name.localeCompare(b.name) || Number(a.remote) - Number(b.remote));
}

async function git(cwd, args, on) {
  const result = await exec("git", args, { cwd, on });
  return { ok: result.code === 0, out: (result.stdout ?? "").trim(), err: (result.stderr ?? result.stdout ?? "").trim() };
}

// The repository's main checkout and the folder's current checkout.
async function repoOf(folder, on) {
  const top = await git(folder, ["rev-parse", "--show-toplevel"], on);
  const common = await git(folder, ["rev-parse", "--path-format=absolute", "--git-common-dir"], on);
  if (!top.ok || !common.ok) return null;
  const main = pathOf(common.out).endsWith("/.git") ? pathOf(common.out).slice(0, -5) : pathOf(common.out);
  return { top: pathOf(top.out), main, name: main.split("/").pop() };
}

// The space currently showing a checkout. The deepest checkout wins when paths nest.
function spaceOf(path, all, on, spaceList, paneList) {
  const target = pathOf(path);
  const inside = (folder, dir) => folder === dir || folder.startsWith(dir + "/");
  return spaceList.find((s) => (s.machine ?? null) === (on ?? null) && (() => {
    const current = pathOf(place(s, paneList));
    if (!current || !inside(current, target)) return false;
    return !all.some((checkout) => checkout.path !== path && checkout.path.length > target.length && inside(current, pathOf(checkout.path)));
  })());
}

function worktrunkResult(result) {
  const line = (result.stdout ?? "").split("\n").find((value) => value.trim().startsWith("{"));
  if (!line) return null;
  try { return JSON.parse(line); } catch { return null; }
}

export default class Worktrunk extends View {
  init(_props, cx) {
    this.on = spaces().find((s) => s.active)?.machine ?? null;
    this.folder = place(spaces().find((s) => s.active));
    this.text = props()?.branch ?? "";
    this.input = InputState.new({ value: this.text, placeholder: "filter or enter a branch name" });
    this.input.on("change", (_e, cx) => { this.text = this.input.value(); this.error = ""; this.at = 0; cx.notify(); });
    this.input.on("submit", (_e, cx) => this.go(cx));
    this.inputFocused = true;
    this.input.on("focus", (_e, cx) => { this.inputFocused = true; cx.notify(); });
    this.input.on("blur", (_e, cx) => { this.inputFocused = false; cx.notify(); });
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.busy = false;
    this.error = "";
    this.repo = undefined; // undefined: looking, null: not in git
    this.checkouts = undefined;
    this.list = undefined;
    this.at = 0;
    this.handle = cx.focus_handle();
    cx.spawn(async (cx) => {
      try {
        if (!this.folder) throw new Error("This space has no folder.");
        const repo = await repoOf(this.folder, this.on);
        if (repo) {
          const checkoutList = await checkouts(repo, this.on);
          this.repo = repo;
          this.checkouts = checkoutList;
          this.list = await branches(repo, this.on, checkoutList);
        } else {
          this.repo = null;
        }
      } catch (error) {
        this.repo = null;
        this.error = String(error);
      }
      cx.notify();
    });
  }

  close() {
    closeOverlay(props()?.overlay);
  }

  shown() {
    const name = this.text.trim();
    const filter = name.toLowerCase();
    const matches = (this.list ?? []).filter((branch) => !filter || branch.name.toLowerCase().includes(filter));
    const exact = matches.find((branch) => branch.name === name);
    if (exact) return [exact];
    if (!name) return matches;
    return [...matches, { create: true, name }];
  }

  go(cx) {
    if (this.busy || !this.repo) return;
    const name = this.text.trim();
    const selected = this.shown()[this.at];
    if (selected) return this.choose(selected, cx);
    if (!name) {
      this.error = "Type a branch name or select a branch.";
      return cx.notify();
    }
    cx.spawn(async (cx) => this.openOrCreate(cx, name));
  }

  choose(branch, cx) {
    if (branch.create) return cx.spawn(async (cx) => this.openOrCreate(cx, branch.name));
    if (branch.checkout) return this.open(branch.checkout);
    cx.spawn(async (cx) => this.openOrCreate(cx, branch.name));
  }

  async openOrCreate(cx, branch) {
    this.busy = true;
    this.error = "";
    cx.notify();
    try {
      let result = await exec("wt", ["switch", branch, "--no-cd", "--format", "json"], { cwd: this.folder, on: this.on });
      if (result.code !== 0)
        result = await exec("wt", ["switch", "--create", branch, "--no-cd", "--format", "json"], { cwd: this.folder, on: this.on });
      if (result.code !== 0) throw new Error(result.stderr?.trim() || result.stdout?.trim() || "wt switch failed.");
      const switched = worktrunkResult(result);
      if (!switched?.path) throw new Error("wt did not return a worktree path.");
      run("space.new", { folder: pathOf(switched.path), machine: this.on });
      this.close();
    } catch (error) {
      this.error = String(error);
    }
    this.busy = false;
    cx.notify();
  }

  open(checkout) {
    if (!checkout) return;
    this.close();
    const selected = spaceOf(checkout.path, this.checkouts ?? [], this.on, spaces(), panes());
    if (selected) run("space.select", { id: selected.id });
    else run("space.new", { folder: checkout.path, machine: this.on });
  }

  key(e, cx) {
    if (e.key === "escape") return this.close();
    const rows = this.shown();
    if ((e.key === "down" || e.key === "up") && rows.length) this.at = (this.at + (e.key === "down" ? 1 : rows.length - 1)) % rows.length;
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  render(cx) {
    const t = theme();
    const r = this.repo;
    const rows = this.shown();
    const all = this.list ?? [];
    const checkoutList = this.checkouts ?? [];
    const spaceList = spaces();
    const paneList = panes();
    const row = (branch, i) => {
      const selected = i === this.at;
      const open = branch.checkout && spaceOf(branch.checkout.path, checkoutList, this.on, spaceList, paneList);
      return v_flex()
        .id(`wt-${i}`)
        .flex_none()
        .h(38)
        .px(10)
        .justify_center()
        .rounded(7)
        .cursor_pointer()
        .when(selected, (el) => el.bg(t.selected))
        .when(!selected, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click((_e, cx) => this.choose(branch, cx))
        .child(
          h_flex()
            .gap(8)
            .child(div().flex_1().min_w(0).truncate().text_color(branch.create ? t.accent : t.foreground).child(branch.create ? `＋ Create new branch "${branch.name}"` : branch.name))
            .when(branch.remote, (el) => el.child(div().flex_none().text_size(11).text_color(t.dim).child("remote")))
            .when(branch.checkout?.main, (el) => el.child(div().flex_none().text_size(11).text_color(t.dim).child("main checkout")))
            .when(Boolean(open), (el) => el.child(div().flex_none().text_size(11).text_color(t.accent).child("open"))),
        );
    };
    const visible = rows.filter((branch) => !branch.create).length;
    const count = visible === all.length ? `${all.length} branches` : `${visible}/${all.length} branches`;
    return v_flex()
      .id("worktrunk")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .size_full()
      .p(16)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .child(h_flex().child(div().flex_1().font_semibold().text_color(t.foreground).child(`Worktrunk${r ? ` of ${r.name}` : ""}`)).child(div().text_size(11).text_color(t.dim).child(r ? count : "")))
      .when(r === undefined, (el) => el.child(div().text_color(t.muted).child("…")))
      .when(r === null, (el) => el.child(div().text_color(t.muted).child(this.folder ? `${this.folder} is not in a git repository.` : "This space has no folder.")))
      .when(Boolean(r && this.list), (el) =>
        el
          .child(Input.new(this.input).h(32).px(10).items_center().rounded(6).border(1).border_color(this.inputFocused ? t.accent : t.input).bg(t.background).text_color(t.foreground))
          .child(
            div()
              .relative()
              .flex_1()
              .min_h(0)
              .child(v_flex().id("wt-list").size_full().overflow_y_scroll().children(rows.map(row)).when(rows.length === 0, (empty) => empty.child(div().p(10).text_color(t.dim).child("No matching branches. Enter creates a new one."))))
              .child(Scrollbar.vertical("wt-list").absolute().inset_0()),
          ),
      )
      .when(Boolean(this.error), (el) => el.child(div().text_color(t.blocked).child(this.error)))
      .child(h_flex().justify_end().text_size(11).text_color(t.dim).child(this.busy ? "working…" : "↑↓ choose · ↵ open/create · esc close"));
  }
}
