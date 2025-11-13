// ==UserScript==
// @name         Disable Website Keyboard Shortcuts
// @namespace    http://tampermonkey.net/
// @version      1
// @description  Trying my best to make Firefox into Neovim
// @author       Dante Criscio
// @include      *
// @grant        none
// @run-at document-start
// ==/UserScript==

// Use @exclude to enumerate any sites for which this script should not apply
// Or use window.location.href within the UserScript to disable only a portion of these shortcuts per-site
(function() {
    'use strict';

    const ignored_keys = new Set([
        // Tree Style Tabs, navigate it like vim
        'h',
        'j',
        'k',
        'l',
        // Tree Style Tabs, extra
        's', // Toggle "Tree Style Tab" Sidebar
        'p', // Toggle Tree Collapsed
        // Dark Reader
        'm', // Toggle current site
    ]);

    ['keydown', 'keyup'].forEach((eventName) => {
        window.addEventListener(
            eventName,
            (e) => {
                if (e.metaKey && ignored_keys.has(e.key)) {
                    e.stopPropagation();
                }
            },
            true // capturing phase - very important
        )
    });
})();
