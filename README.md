# macDotfiles

## Overview and Scope
Makes it easy for me to automatically synchronize my very specific settings between multiple macbooks.
The specific settings which it synchronizes are primarily aimed at editing in terminal.
As such, doing things like installing Google Chrome and making it the default browser are not a priority.
However, installing iTerm2, configuring it, and making it the default terminal would be a priority.

## Bootstrapping a brand-new Macbook
* Install homebrew and git
* Use Mac's built-in terminal application
  * Use this because iTerm2 is going to be installed and then configured
* Clone the repo into some new directory (not the ~/.config directory).
* `cd` into that new directory.
* Execute the 2 given scripts as needed.
* Restart the Macbook

## The Scripts
### install.zsh
* Preforms almost all installations using homebrew, so ensure that `brew ` is installed.
* Installs all dependencies for neovim
  * A hacked nerd font
  * `fd` and `ripgrep` (for telescope)
* Installs neovim
* Installs iTerm2
* Installs amethyst
* Installs oh-my-zsh
  * Critically however, it does not modify `~/.zshrc` file at all

### setPreferences.zsh
* Modifies several plist files within `~/Library/Preferences`
  * These update mac specific settings and keybindings
  * Also updates settings and keybindings for iTerm2 and amethyst
* Clone's my neovim config from github into the correct location
* Makes `vim` an alias for `nvim`
* Adds oh-my-zsh configuration to `~/.zshrc`
* Caveats:
  * For updates to iTerm2 to work, the script must be called from some other terminal (like the built-in terminal)
  * Additionally, for most MacOS settings changes to be observed, the computer should be restarted after running.
