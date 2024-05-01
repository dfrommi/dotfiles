## Installation

### Passwordless sudo

Run
```
echo "$(whoami) ALL=(root) NOPASSWD:SETENV: sha256:$(shasum -a 256 $HOME/thirdparty/bin/kanata | cut -d " " -f 1) $HOME/thirdparty/bin/kanata -c $HOME/.config/kanata/kanata.kbd"
```

and paste output to
```
sudo visudo -f /private/etc/sudoers.d/kanata
```


## Launchagent

Copy script

```
cp github.jtroo.kanata.plist ~/Library/LaunchAgents/
```

and start

```
launchctl load -w ~/Library/LaunchAgents/github.jtroo.kanata.plist
```

