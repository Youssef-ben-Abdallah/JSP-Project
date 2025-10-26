(function () {
    function pad(value) {
        return value.toString().padStart(2, '0');
    }

    function updateCountdown(element, endTime) {
        if (!endTime) {
            element.textContent = 'Expirée';
            element.classList.add('is-expired');
            return;
        }
        var now = new Date().getTime();
        var distance = endTime - now;
        if (distance <= 0) {
            element.textContent = 'Expirée';
            element.classList.add('is-expired');
            return;
        }
        var hours = Math.floor(distance / (1000 * 60 * 60));
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);
        var segments = element.querySelectorAll('.countdown-segment');
        if (segments.length === 3) {
            segments[0].textContent = pad(hours);
            segments[1].textContent = pad(minutes);
            segments[2].textContent = pad(seconds);
        } else {
            element.textContent = pad(hours) + ':' + pad(minutes) + ':' + pad(seconds);
        }
    }

    function initialisePromotions() {
        var cards = document.querySelectorAll('.promo-highlight-card');
        if (!cards.length) {
            return;
        }
        cards.forEach(function (card) {
            var endIso = card.getAttribute('data-end-time');
            var countdown = card.querySelector('.promo-countdown');
            if (!endIso || !countdown) {
                return;
            }
            var endDate = new Date(endIso.replace(' ', 'T'));
            updateCountdown(countdown, endDate.getTime());
            setInterval(function () {
                updateCountdown(countdown, endDate.getTime());
            }, 1000);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialisePromotions);
    } else {
        initialisePromotions();
    }
})();
