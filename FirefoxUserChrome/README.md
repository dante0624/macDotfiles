## What is UserChrome
The word "Chrome" (used before Google Chrome) was used to reference the "Heads Up Display" of the browser.
It includes the tab bar, back arrows, search bar, and any other content that wraps around the webpages's html.
Very conviently, firefox treats this content like HTML as well!
The chrome is some outer-html DIVs, and the webpages's content is just a DIV inside of that.

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
- UserChrome.js (very often called autoconfig.js) allows for editing just about anyting about Firefox
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
* https://superuser.com/questions/1271147/change-key-bindings-keyboard-shortcuts-in-firefox-57
* https://www.userchrome.org/what-is-userchrome-js.html
* https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

