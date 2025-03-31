// IMPORTANT: Start your code on the 2nd line
try {
  const Services = globalThis.Services;
  function ConfigJS() {
    Services.obs.addObserver(this, 'chrome-document-global-created', false);
  }
  ConfigJS.prototype = {
    observe: function (aSubject) {
      aSubject.addEventListener('DOMContentLoaded', this, {once: true});
    },
    handleEvent: function (aEvent) {
      let document = aEvent.originalTarget;
      let window = document.defaultView;
      let location = window.location;
      if (/^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(location.href)) {
        if (window.Tabbrowser) {
          // Remove many keymaps that I don't fine useful
          const removeList = [
            "key_findSelection", // accel + E
            "key_findAgain", // accel + G
            "key_hideThisAppCmdMac", // accel + H
            "key_openDownloads", // accel + J
            "key_search", // accel + K
            "focusURLBar", // accel + L
            "key_minimizeWindow", // accel + M
            "key_newNavigator", // accel + N
            "openFileKb", // accel + O
            "printKb", // accel + P
            "key_savePage", // accel + S
            "showAllHistoryKb", // accel + Y
          ]
          for (const keyId of removeList) {
            window.document.getElementById(keyId).remove();
          }

          // Remap "Bookmark this page" from accel + D to accel + S. Frees this up for Dark Mode Plugin.
          const bookmarkPage = window.document.getElementById("addBookmarkAsKb");
          bookmarkPage.setAttribute("modifiers", "accel"); // Should already have this modifier, but just to be safe
          bookmarkPage.setAttribute("key", "S");

          // Remap RoggleReaderView from accel,alt + R to accel + E because I want to use it often.
          const toggleReaderView = window.document.getElementById("key_toggleReaderMode");
          toggleReaderView.setAttribute("modifiers", "accel");
          toggleReaderView.setAttribute("key", "E");

          // Remap ReloadSkipCache from accel,shift + R to accel,alt + R. Frees this up for reloading a tree of tabs.
          const reloadSkipCache = window.document.getElementById("key_reload_skip_cache");
          reloadSkipCache.setAttribute("modifiers", "accel,alt");
          reloadSkipCache.setAttribute("key", "R"); // Should already have this key, but just to be safe
        }
      }
    },
  };
  if (!Services.appinfo.inSafeMode) {
    new ConfigJS();
  }
} catch(ex) {};
