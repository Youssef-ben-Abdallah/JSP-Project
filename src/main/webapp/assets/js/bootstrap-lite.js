// Minimal behaviors for navbar collapse and dropdowns without the full Bootstrap bundle
(function() {
  function ready(fn) {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", fn);
    } else {
      fn();
    }
  }

  ready(function() {
    // Collapse toggles
    document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(toggle) {
      var targetSelector = toggle.getAttribute('data-bs-target') || toggle.getAttribute('href');
      if (!targetSelector) return;
      var target = document.querySelector(targetSelector);
      if (!target) return;
      toggle.addEventListener('click', function(event) {
        event.preventDefault();
        target.classList.toggle('show');
      });
    });

    // Dropdown toggles
    document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(function(trigger) {
      var dropdown = trigger.closest('.dropdown');
      if (!dropdown) return;
      trigger.addEventListener('click', function(event) {
        event.preventDefault();
        dropdown.classList.toggle('show');
      });
    });

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(event) {
      document.querySelectorAll('.dropdown.show').forEach(function(openDropdown) {
        if (!openDropdown.contains(event.target)) {
          openDropdown.classList.remove('show');
        }
      });
    });
  });
})();
