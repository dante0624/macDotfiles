## What is UserChrome
The word "Chrome" (used before Google Chrome) was used to reference the "Heads Up Display" of the browser.
It includes the tab bar, back arrows, search bar, and any other content that wraps around the webpages's html.
Very conveniently, Firefox treats this content like HTML as well!
The chrome is some outer-html DIVs, and the webpages's content is like a DIV inside of that.

### Debugging the Chrome
Firefox has a feature for inspecting the chrome content like normal "inspect element" but it is kind of hidden.
The steps to use it are:
1. Go to normal inspect element
1. Click `...` just left of the closing `x`
1. Click `settings`
1. Under `Advanced settings` enable two things:
    1. Enable browser chrome and add-on debugging toolboxes
    1. Enable remote debugging
1. Close this normal inspect element
1. Go to Hamburger menu > More Tools > Browser Toolbox
1. Allow the incoming connection
1. To debug how things look:
    1. Open this debugger window in split-screen
    1. Hovering over an HTML DIV will highlight that DIV, just like in normal inspect element
1. To debug keyboard shortcuts
    1. In the Inspector, search for #mainKeyset
    1. There, you see all assigned keyboard shortcuts
    1. Can right-click on one and choose "Use in Console" to inspect it more

### User Chrome
Firefox allows for (but only barely supports) users modifying this chrome at Firefox startup time.
- UserChrome.css allows for changing the chrome's CSS Content
  - This is more supported by Mozilla.
- UserChrome.js (very often called autoconfig.js) allows for editing just about anything about Firefox
  - This has much less support from Mozilla.
  - They encourage using it for just setting preferences
  - I prefer to use it to change keybindings, since these are also under the Chrome content.

Because both of these work at startup time, any modifications require fully closing and re-opening Firefox.

## Tree Style Tab (TST)
The motivation for modifying the UserChrome is to make it work nicely with Firefox's TST plugin.
This plugin is the singular reason I use Firefox, as it makes juggling many tabs significantly less stressful.
The motivation for modifying `userChrome.css` is to remove the tabs from the top and only have them on the sides.
The motivation for modifying `userChrome.js` is to remove builtin keybindings so they can be used by the TST plugin.
These will specifically be used to easily navigate tabs like vim.

### Miscellaneous TST Configurations
1. First, TST needs to be installed
1. Next, disable Firefox's builtin sidebar
    1. Go to `about:preferences` (the URL) -> `Browser Layout` -> Uncheck `Show sidebar`
    1. This will get rid of an extra div on the left side which allows for choosing between tabs, history, bookmarks, or AI.
    1. I prefer to not use this, and have the tabs be the only thing on the left side.
1. Add a bookmark whose name is `Group` and URL is `about:treestyletab-group`
    1. This is very useful for creating a tab whose only job is to be a parent for other tabs
1. Go through the steps of modifying the `userChrome.css`
1. Go through the steps of modifying the `userChrome.js` (just run a single shell script)
    1. After this, restart Firefox
    1. Then update keyboard shortcuts within the TST extension based on the `plan.txt` file in this directory
1. Download TamperMonkey and add the script within this directory to disallow certain sites from using these keyboard shortcuts.
1. [If Desired] Bookmarks can be configured to only show up on new tabs
    1. Set View -> Toolbars -> Bookmarks Toolbar -> Only Show on New Tab
    1. Next, deactivate a TST feature which does not play nicely with "Only Show on New Tab"
        1. TST options -> "More..." -> check "Unlock Expert Options"
        1. TST options -> Appearance -> uncheck "Blank new tab on Firefox 85 and later"
        1. For more info, read through https://github.com/piroor/treestyletab/issues/3798
1. [If Desired] change the colorscheme with TST options -> Appearance -> Theme -> Proton

## UserChrome.css
### Setting Up
1. Type `about:config` in the URL bar
1. Choose `Accept the Risk and Continue`
1. Type `toolkit.legacy` in the URL bar
    1. Ensure that `toolkit.legacy` is a boolean
    1. Ensure that `toolkit.legacyUserProfileCustomizations.stylesheets` is true
        1. If false, double click if to make it true.
1. Type `about:profiles` in the URL bar
1. Find the profile which is currently in use (is likely the default profile)
1. Note the value of `Root Directory`
1. Go this directory, and make a new directory called `chrome`
1. Create a symlink in this new directory called `userChrome.css`, which points to the existing `userChrome.css` file.
1. Restart Firefox.


## UserChrome.js
### Setting Up
**Note that there is already a script called setup_autoconfig.sh which does all of this**
1. First note a base-path of `/Applications/Firefox.app/Contents/Resources/`
1. Create a symbolic link of config.js into the base-path
1. Use `mkdir` (if needed) to create the sub-path: `defaults/pref`
1. Create a symbolic link of autoconfig.js into this sub-path

### Source of Information (In Order of Helpfulness)
1. https://superuser.com/questions/1271147/change-key-bindings-keyboard-shortcuts-in-Firefox-57
1. https://www.userchrome.org/what-is-userchrome-js.html
1. https://support.mozilla.org/en-US/kb/customizing-Firefox-using-autoconfig

## Plans For Turning Firefox Into Neovim As Much As Possible
### Phase 1 - Finalize the Existing Extension Shortcuts
Whenever a keyboard shortcut is pressed, it can be consumed by multiple sources which are checked in this order:
1. The webpage itself listens for the keypress
    1. Can use a simple tampermonkey script to prevent all webpage from listening to my shortcuts
1. The keyboard shortcuts in UserChrome listen for the keypress
    1. Can use use userChrome.js to disable and re-bind these
1. Extensions listen for the keypress
    1. These can be edited interactively. Go to url `about:addons` -> Gear Symbol -> "Manage Extension Shortcuts"
1. MacOS's window (Firefox in this case) listens for the keypress
    1. MacOS has its own system for storing keyboard shortcuts per application
    1. These can easily be overwritten, but I think that removing them is a little annoying

Will finalize which keyboard shortcuts I use from TST, and ensure they are removed from everything else.

### Phase 2 - Add a Harpoon-Style Plugin
- Can "pin" certain tabs without changing their position in the tree at all.
  - Each pinned tab will go into one of ten slots (maximum).
- Can use an interactive window that pops up and allows for re-ordering the pinned tabs.
  - Can use this interactive window with the mouse or entirely with the keyboard
  - Escape will close the window
- Can use a prefix key (Command + o) to begin choosing a pinned tab.
  - Then each key of the the home row corresponds to each slot 1-10.
  - After the prefix key, some other key opens the interactive window.
  - The prefix key is the only command that the extension exposes to users.

### Phase 3 - Add a Simple Telescope-Style Plugin
- Expose one command for opening a fuzzyfinder over both bookmarks and open tabs (reads from both sources).
  - I would like the fuzzyfinder to work similarly to NeoVim's Telescope.
  - It should begin in "insertion mode".
  - After escape is pressed, we are in "normal mode". Here, "j" and "k" can move up an down the query results.
  - Then "i" and "a" move back to "insertion mode" at the end of the current query text.
  - No need to visual mode or any other complications.
- Expose another command for opening a fuzzyfinder over the contents of these tabs
  - This may need to be cut since it is difficult, but would be powerful if I can do it.
  - Ideally it doesn't scan the RAW HTML file. Instead it should read the same text that Command + F reads.

### Phase 4 - Make a Single Script For Installing All Firefox Stuff
It should install all extensions, set keyboard shortcuts on all of them, and do the userChrome stuff.

## Miscellaneous Plans
- Small tampermonkey script specifically for Quip
  - It should open in both "Focus Mode" and "View-only Mode"
- Make the existing Vim plugin work everywhere
  - The biggest issue with this plugin is that it seems to be disabled on many sites that I use for work
  - It also notably doesn't work in ReaderMode, which I would like to use more often
  - See if I can find some way to disable these seemingly arbitrary restrictions
- Make the New-Tab page look pretty, without any news articles

