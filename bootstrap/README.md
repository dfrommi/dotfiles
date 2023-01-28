## Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install packages
```bash
eval $(/opt/homebrew/bin/brew shellenv)

TODO install packages from files
```

## Setup SSH access
Create file `~/.ssh/config` with content
```
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

```

## Clone dotfiles
```bash
git clone git@github.com:dfrommi/dotfiles.git ~/.config

ln -s ~/.config/hammerspoon ~/.hammerspoon
ln -s ~/.config/nvim/idea.vim ~/.ideavimrc
```

