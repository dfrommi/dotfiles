Create a link symlink from `~/.atom` to `~/.config/atom`.

## Packages

*Create package list*

```bash
apm list --installed --bare > ~/.config/atom/package-list.txt
```

*Install packages*

```bash
apm install --packages-file ~/.config/atom/package-list.txt
```
