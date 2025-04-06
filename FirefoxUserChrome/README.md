## What is UserChrome
The word "Chrome" (used before Google Chrome) was used to reference the "Heads Up Display" of the browser.
It includes the tab bar, back arrows, search bar, and any other content that wraps around the webpages's html.
Very conveniently, Firefox treats this content like HTML as well!
The chrome is some outer-html DIVs, and the webpages's content is like a DIV inside of that.

### Debugging the Chrome
Firefox has a feature for inspecting the chrome content like normal "inspect element" but it is kind of hidden.
The steps to use it are:
1. Go to normal inspect element
2. Click `...` just left of the closing `x`
3. Click `settings`
4. Under `Advanced settings` enable two things:
    - Enable browser chrome and add-on debugging toolboxes
    - Enable remote debugging
5. Close this normal inspect element
6. Go to Hamburger menu > More Tools > Browser Toolbox
7. Allow the incoming connection

### User Chrome
Firefox allows for (but only barely supports) users modifying this chrome at Firefox startup time.
- UserChrome.css allows for changing the chrome's CSS Content
  - This is more supported by Mozilla.
- UserChrome.js (very often called autoconfig.js) allows for editing just about anything about Firefox
  - This has much less support from Mozilla.
  - They encourage using it for just setting preferences
  - I prefer to use it to change keybindings, since these are also under the Chrome content.

Because both of these work at startup time, any modifications require fully closing and re-opening Firefox.


## UserChrome.css
### Setting Up
1. Type `about:config` in the URL bar
2. Choose `Accept the Risk and Continue`
3. Type `toolkit.legacy` in the URL bar
    - Ensure that `toolkit.legacy` is a boolean
    - Ensure that `toolkit.legacyUserProfileCustomizations.stylesheets` is true
      - If false, double click if to make it true. Then restart Firefox
4. Type `about:profiles` in the URL bar
5. Note the value of `Root Directory`
6. Go this directory, and make a new directory called `chrome`
7. Create a symlink in this new directory called `userChrome.css`, which points to the existing `userChrome.css` file.


## UserChrome.js
### Setting Up
1. First note a base-path of `/Applications/Firefox.app/Contents/Resources/`
2. Create a symbolc link of config.js into the base-path
3. Use `mkdir` (if needed) to create the sub-path: `defaults/pref`
4. Create a symbolic link of autoconfig.js into this sub-path

### Debugging Interal Firefox Keyboard Shortcuts
* Go to Hamburger menu > More Tools > Browser Toolbox
* Keyboard Shortcuts
  * In the Inspector, search for #mainKeyset
  * There, you see all assigned keyboard shortcuts
* Sidebar
  * In the Inspector, look under <html:body><hbox><vbox>

### Source of Information (In Order of Helpfulness)
* https://superuser.com/questions/1271147/change-key-bindings-keyboard-shortcuts-in-Firefox-57
* https://www.userchrome.org/what-is-userchrome-js.html
* https://support.mozilla.org/en-US/kb/customizing-Firefox-using-autoconfig

## Plans For Turning Firefox Into Neovim As Much As Possible
### Phase 1 - Finalize the Existing Extension Shortcuts
Whenever a keyboard shortcut is pressed, it can be consumed by multiple sources which are checked in this order:
1. The webpage itself listens for the keypress
    - Can use a simple tampermonkey script to prevent all webpage from listening to my shortcuts
2. The keyboard shortcuts in UserChrome listen for the keypress
    - Can use use userChrome.js to disable and re-bind these
3. Extensions listen for the keypress
    - These can be edited interactively. Go to url `about:addons` -> Gear Symbol -> "Manage Extension Shortcuts"
4. MacOS's window (Firefox in this case) listens for the keypress
    - MacOS has its own system for storing keyboard shortcuts per application
    - These can easily be overwritten, but I think that removing them is a little annoying

Will finalize which keyboard shorcuts I use from TST, and ensure they are removed from everything else.

### Phase 2 - Fix Small Bug in Tree Style Tags Shortcut
Wrote up a [github issue](https://github.com/piroor/treestyletab/issues/3725) for it.
I'm planning to use this as justification for just fixing it myself and putting up a Pull Request.

### Phase 3 - Add a Harpoon-Style Plugin
- Can "pin" certain tabs without changing their position in the tree at all.
  - Each pinned tab will go into one of ten slots (maximum).
- Can use an interactive window that pops up and allows for re-ordering the pinned tabs.
  - Can use this interactive window with the mouse or entirely with the keyboard
  - Escape will close the window
- Can use a prefix key (Command + o) to begin choosing a pinned tab.
  - Then each key of the the home row corresponds to each slot 1-10.
  - After the prefix key, some other key opens the interactive window.
  - The prefix key is the only command that the extension exposes to users.

### Phase 4 - Add a Simple Telescope-Style Plugin
- Expose one command for opening a fuzzyfinder over both bookmarks and open tabs (reads from both sources).
  - I would like the fuzzyfinder to work similaly to NeoVim's Telescope.
  - It should begin in "insertion mode".
  - After escape is pressed, we are in "normal mode". Here, "j" and "k" can move up an down the query results.
  - Then "i" and "a" move back to "insertion mode" at the end of the current query text.
  - No need to visual mode or any other complications.
- Expose another command for opening a fuzzyfinder over the contents of these tabs
  - This may need to be cut since it is difficult, but would be powerful if I can do it.
  - Ideally it doesn't scan the RAW HTML file. Instead it should read the same text that Command + F reads.

### Phase 5 - Make a Single Script For Installing All Firefox Stuff
It should install all extensions, set keyboard shortcuts on all of them, and do the userChrome stuff.

## Miscellaneous Plans
- Small tampermonkey script specifically for Quip
  - It should open in both "Focus Mode" and "View-only Mode"
- Make the existing Vim plugin work everywhere
  - The biggest issue with this plugin is that it seems to be disabled on many sites that I use for work
  - It also notably doesn't work in ReaderMode, which I would like to use more often
  - See if I can find some way to disable these seemingly arbitrary restrictions
- Make the New-Tab page look pretty, without any news articles

