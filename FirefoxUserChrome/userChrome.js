// -*- mode: javascript; -*- vim: set ft=javascript:
// See https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
"use strict";

(() => {
  if (Services.appinfo.inSafeMode) {
    return;
  }

  const addressPattern = new RegExp(
    "^(chrome:(?!//(global/content/commonDialog)\\.xhtml)|about:(?!blank))"
  );

  Services.obs.addObserver(subject => {
    subject.addEventListener(
      "DOMContentLoaded",
      event => {
        const document = event.originalTarget;
        const window = document.defaultView;
        if (!addressPattern.test(window.location.href)) {
          return;
        }
        // Remove many keymaps that I don't find useful
        const removeList = [
          "key_findSelection", // accel + E
          "key_findAgain", // accel + G
          "key_hideThisAppCmdMac", // accel + H
          "key_openDownloads", // accel + J
          "key_search", // accel + K
          "focusURLBar", // accel + L
          "key_minimizeWindow", // accel + M
          "openFileKb", // accel + O
          "printKb", // accel + P
          "key_savePage", // accel + S
          "showAllHistoryKb", // accel + Y
        ]
        for (const keyId of removeList) {
          document.getElementById(keyId).remove();
        }

        // Uncomment this is you prefer `about:preferences` (go to URL) -> Browser Layout -> Show sidebar

        // Remap "Toggle Sidebar" from control + Z to accel + S.
        // const toggleSidebar = document.getElementById("toggleSidebarKb");
        // toggleSidebar.setAttribute("modifiers", "accel");
        // toggleSidebar.setAttribute("key", "S");
        // toggleSidebar.setAttribute("data-l10n-id", "toggle-sidebar-shortcut-MODIFIED");

        // Remap ToggleReaderView from accel,alt + R to accel + E because I want to use it often.
        const toggleReaderView = document.getElementById("key_toggleReaderMode");
        toggleReaderView.setAttribute("modifiers", "accel");
        toggleReaderView.setAttribute("key", "E");
        toggleReaderView.setAttribute("data-l10n-id", "reader-mode-toggle-shortcut-other-MODIFIED");

        // Remap ReloadSkipCache from accel,shift + R to accel,alt + R. Frees this up for reloading a tree of tabs.
        const reloadSkipCache = document.getElementById("key_reload_skip_cache");
        reloadSkipCache.setAttribute("modifiers", "accel,alt");
        reloadSkipCache.setAttribute("key", "R"); // Should already have this key, but just to be safe
        reloadSkipCache.setAttribute("data-l10n-id", "nav-reload-shortcut-MODIFIED");
      },
      { once: true }
    );
  }, "chrome-document-global-created");
})();
