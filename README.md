# rcruzper/dotfiles

![](https://raw.githubusercontent.com/rcruzper/dotfiles/master/screenshot.png)

This is my set of configuration files to get ready in any new machine. If you want to know more about dotfiles, see [dotfiles.github.io](https://dotfiles.github.io/).

## 📦 Requirements

- User password is required to fix brew permissions and add zsh as default shell

## 🚀 Installation

```shell
git clone --recursive git@github.com:rcruzper/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

If you want to update the configuration, you just need to execute `cd ~/.dotfiles && make` again.

### iTerm2 configuration (optional)

If you want to see iTerm2 as the image below you need to enable option 'Load preferences from a custom folder or URL:' in General Tab with path '~/.dotfiles/iterm2'

## 🐛 Bugs

If you have any problem installing dotfiles, please [open an issue](https://github.com/rcruzper/dotfiles/issues).
