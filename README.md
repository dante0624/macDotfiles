# macDotfiles

## Overview and Scope
Makes it easy for me to automatically synchronize my very specific settings between multiple macbooks.
The specific settings which it synchronizes are primarily aimed at making keyboard shortcuts work exactly how I want.

## Bootstrapping a brand-new Macbook
* Install homebrew and git
* Use Mac's built-in terminal application
  * Use this because WezTerm is going to be installed and then configured
* Clone the repo into `$HOME` directory
  * This is necessary because other symlinks and scripts will assume that these files can be found in this location
* `cd` into that new directory.
* Execute the 2 given scripts as needed.
* Restart the Macbook

## The Scripts
### install.zsh
* Preforms almost all installations using homebrew, so ensure that `brew` is installed.
* Installs Amethyst
* Installs dependencies for neovim
  * `fd` and `ripgrep` (for telescope)
* Installs WezTerm
* Installs fish
* Installs neovim
* Installs Firefox

### setPreferences.zsh
* Configures WezTerm display and keyboard shortcuts
* Makes fish the default shell and configures the shell:
  * Tweaks appearances, like the colors, shell prompt, and git prompt
  * Sets up aliases / fish functions
* Clone's my neovim config from github into the correct location
* Makes neovim the default git editor
* Modifies several plist files within `$HOME/Library/Preferences`
  * These update mac specific settings and keybindings
  * Also updates settings and keybindings for Amethyst and Firefox
* Compiles and sets up a swift script for quickly selecting windows called `my-window-selector`
* Sets up Launch Agents, so that certain actions are taken when the Macbook restarted
* Caveats:
  * MacOS settings changes to be observed, the computer should be restarted after running.
  * For `my-window-selector`, the bootstrapping process is extra annoying:
    * First the app must be given permissions
    * Then the Launch Agent must re-start its attempt at running the application

