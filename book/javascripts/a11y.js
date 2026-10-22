/* Accessibility repairs for the Zensical theme, shared by every textbook
   in the family. Synced from shared/javascripts/a11y.js: never edit the
   copy inside a course repo.

   Why this file exists: axe-core (WCAG 2.1 AA) reported the same five
   theme defects on every page of every book (2026-10-22 evaluation):
   wide-table scroll regions with no keyboard access, header toggle
   labels carrying aria-label without a role, the search dialog's two
   icon buttons with no accessible name, and its combobox input without
   aria-expanded or aria-controls. The theme's HTML cannot be edited
   from a book, so this script repairs the rendered DOM. Keep it small,
   dependency-free, and safe to run more than once. */
(function () {
  "use strict";

  function fixLabels() {
    document.querySelectorAll("label.md-overlay[aria-label]").forEach(function (label) {
      /* The overlay is a click target behind the drawer, not a control. */
      label.removeAttribute("aria-label");
      label.setAttribute("aria-hidden", "true");
    });
    document.querySelectorAll("label.md-header__button[aria-label][for]").forEach(function (label) {
      if (label.getAttribute("role") === "button") return;
      var box = document.getElementById(label.getAttribute("for"));
      label.setAttribute("role", "button");
      label.setAttribute("tabindex", "0");
      if (box) {
        var sync = function () { label.setAttribute("aria-expanded", box.checked ? "true" : "false"); };
        box.addEventListener("change", sync);
        sync();
      }
      label.addEventListener("keydown", function (event) {
        if (event.key === "Enter" || event.key === " ") {
          event.preventDefault();
          label.click();
        }
      });
    });
  }

  function fixTables() {
    document.querySelectorAll(".md-typeset__scrollwrap:not([tabindex])").forEach(function (wrap) {
      var caption = wrap.querySelector("caption");
      var firstHeader = wrap.querySelector("th");
      var name = "Scrollable table";
      if (caption && caption.textContent.trim()) {
        name = caption.textContent.trim();
      } else if (firstHeader && firstHeader.textContent.trim()) {
        name = "Table starting with the column " + firstHeader.textContent.trim();
      }
      wrap.setAttribute("tabindex", "0");
      wrap.setAttribute("role", "region");
      wrap.setAttribute("aria-label", name);
    });
  }

  /* The search dialog lives in an open shadow root appended to <body>.
     Its icon buttons are identified by their Lucide icon class. */
  var ICON_NAMES = {
    "lucide-search": "Search",
    "lucide-list-filter": "Show or hide search filters",
    "lucide-x": "Clear the search"
  };

  function fixSearch(root) {
    root.querySelectorAll("button").forEach(function (button) {
      if (button.textContent.trim() || button.getAttribute("aria-label")) return;
      var svg = button.querySelector("svg");
      var classes = svg ? (svg.getAttribute("class") || "") : "";
      var name = "Search control";
      Object.keys(ICON_NAMES).forEach(function (key) {
        if (classes.indexOf(key) >= 0) name = ICON_NAMES[key];
      });
      button.setAttribute("aria-label", name);
    });
    /* Panels inside the dialog scroll (results, filters) but hold no
       focusable content until a search runs, so give each one a tab stop. */
    root.querySelectorAll("div").forEach(function (panel) {
      if (panel.hasAttribute("tabindex")) return;
      var overflow = getComputedStyle(panel).overflowY;
      if (overflow !== "auto" && overflow !== "scroll") return;
      if (panel.querySelector("a[href], button, input, [tabindex]")) return;
      var heading = panel.querySelector("h1, h2, h3, h4");
      panel.setAttribute("tabindex", "0");
      panel.setAttribute("role", "region");
      panel.setAttribute("aria-label", heading && heading.textContent.trim() ? heading.textContent.trim() : "Search panel");
    });
    root.querySelectorAll("input[role=\"combobox\"]").forEach(function (input) {
      if (input.getAttribute("data-a11y") === "done") return;
      input.setAttribute("data-a11y", "done");
      var list = root.querySelector("[role=\"listbox\"], ol, ul");
      if (list) {
        if (!list.id) list.id = "zs-search-results";
        input.setAttribute("aria-controls", list.id);
      }
      input.setAttribute("aria-expanded", "false");
      input.setAttribute("aria-autocomplete", "list");
      if (!input.getAttribute("aria-label")) input.setAttribute("aria-label", input.getAttribute("placeholder") || "Search");
      input.addEventListener("input", function () {
        input.setAttribute("aria-expanded", input.value ? "true" : "false");
      });
    });
  }

  function scanShadowRoots() {
    Array.prototype.forEach.call(document.body.children, function (child) {
      if (!child.shadowRoot) return;
      fixSearch(child.shadowRoot);
      if (child.getAttribute("data-a11y-observed") === "true") return;
      child.setAttribute("data-a11y-observed", "true");
      new MutationObserver(function () { fixSearch(child.shadowRoot); })
        .observe(child.shadowRoot, { childList: true, subtree: true });
    });
  }

  function run() {
    fixLabels();
    fixTables();
    scanShadowRoots();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
  /* The search dialog is appended after load, and instant navigation can
     re-render the page body, so keep watching the top level of <body>. */
  new MutationObserver(function () { scanShadowRoots(); fixTables(); })
    .observe(document.body, { childList: true });
  window.addEventListener("popstate", run);
})();
