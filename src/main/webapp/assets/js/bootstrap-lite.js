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

    // Lightweight modal handling
    var activeBackdrop = null;

    function showModal(modal) {
      if (!modal) return;
      modal.classList.add('show');
      modal.removeAttribute('aria-hidden');
      modal.setAttribute('aria-modal', 'true');
      document.body.style.overflow = 'hidden';

      activeBackdrop = document.createElement('div');
      activeBackdrop.className = 'modal-backdrop';
      document.body.appendChild(activeBackdrop);
    }

    function hideModal(modal) {
      if (!modal) return;
      modal.classList.remove('show');
      modal.setAttribute('aria-hidden', 'true');
      modal.removeAttribute('aria-modal');
      document.body.style.overflow = '';

      if (activeBackdrop) {
        activeBackdrop.remove();
        activeBackdrop = null;
      }
    }

    document.querySelectorAll('[data-bs-toggle="modal"]').forEach(function(trigger) {
      var targetSelector = trigger.getAttribute('data-bs-target');
      var modal = targetSelector ? document.querySelector(targetSelector) : null;
      if (!modal) return;

      trigger.addEventListener('click', function(event) {
        event.preventDefault();
        showModal(modal);
      });
    });

    document.querySelectorAll('[data-bs-dismiss="modal"]').forEach(function(closeBtn) {
      closeBtn.addEventListener('click', function(event) {
        event.preventDefault();
        var modal = closeBtn.closest('.modal');
        hideModal(modal);
      });
    });

    document.querySelectorAll('.modal').forEach(function(modal) {
      modal.addEventListener('click', function(event) {
        if (event.target === modal) {
          hideModal(modal);
        }
      });
    });
  });
})();
