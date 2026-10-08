"use strict";

// The published menu uses a button rather than an unfocusable label. Keep
// mdBook's checkbox-driven transition and persisted sidebar state.
const contentsToggle = document.getElementById("mdbook-sidebar-toggle");
const contentsCheckbox = document.getElementById("mdbook-sidebar-toggle-anchor");
if (contentsToggle?.tagName === "BUTTON" && contentsCheckbox) {
    contentsToggle.addEventListener("click", () => contentsCheckbox.click());
}

// A wide table needs a keyboard scroll target as well as touch scrolling.
// Keep tables that fit out of the tab sequence.
for (const wrapper of document.querySelectorAll(".table-wrapper")) {
    let heading = wrapper.previousElementSibling;
    while (heading && !/^H[1-6]$/.test(heading.tagName)) {
        heading = heading.previousElementSibling;
    }
    const label = wrapper.querySelector("caption")?.textContent.trim()
        || (heading ? `${heading.textContent.trim()} table` : "Reference table");
    const update = () => {
        if (wrapper.scrollWidth > wrapper.clientWidth + 1) {
            wrapper.tabIndex = 0;
            wrapper.setAttribute("role", "region");
            wrapper.setAttribute("aria-label", label);
        } else {
            wrapper.removeAttribute("tabindex");
            wrapper.removeAttribute("role");
            wrapper.removeAttribute("aria-label");
        }
    };
    // mdBook uses the same keys for chapter navigation. A focused table owns
    // horizontal arrows so the browser can perform its normal scroll action.
    wrapper.addEventListener("keydown", (event) => {
        if (event.target === wrapper && wrapper.tabIndex === 0
            && (event.key === "ArrowLeft" || event.key === "ArrowRight")) {
            event.stopPropagation();
        }
    });
    new ResizeObserver(update).observe(wrapper);
    update();
}

// Use the current clipboard API on secure origins. mdBook's delegated
// ClipboardJS handler remains available where that API is absent.
if (navigator.clipboard?.writeText && typeof playground_text === "function") {
    for (const button of document.querySelectorAll(".clip-button")) {
        button.addEventListener("click", async (event) => {
            event.preventDefault();
            event.stopImmediatePropagation();
            const message = button.querySelector(".tooltiptext");
            message.setAttribute("role", "status");
            try {
                await navigator.clipboard.writeText(playground_text(button.closest("pre"), false));
                message.textContent = "Copied!";
            } catch {
                message.textContent = "Copy failed. Select the code and copy it.";
            }
            button.classList.add("tooltipped");
        });
    }
}
