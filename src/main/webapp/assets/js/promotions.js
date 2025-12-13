(function () {
    function pad(value) {
        return value.toString().padStart(2, '0');
    }

    var ONE_DAY_MS = 24 * 60 * 60 * 1000;
    var THREE_DAYS_MS = ONE_DAY_MS * 3;

    function setCountdownState(element, state) {
        element.classList.remove('is-warning', 'is-safe', 'is-critical', 'is-expired');
        if (state) {
            element.classList.add(state);
        }
    }

    function updateCountdown(card, element, endTime, intervalId) {
        if (!endTime) {
            element.textContent = 'Expired';
            setCountdownState(element, 'is-expired');
            return true;
        }
        var now = new Date().getTime();
        var distance = endTime - now;

        if (distance <= -ONE_DAY_MS) {
            clearInterval(intervalId);
            card.remove();
            return false;
        }

        if (distance <= 0) {
            element.textContent = 'Expired';
            setCountdownState(element, 'is-expired');
            return true;
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

        if (distance <= ONE_DAY_MS) {
            setCountdownState(element, 'is-critical');
        } else if (distance <= THREE_DAYS_MS) {
            setCountdownState(element, 'is-warning');
        } else {
            setCountdownState(element, 'is-safe');
        }

        return true;
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
            var intervalId = null;
            var tick = function () {
                if (!updateCountdown(card, countdown, endDate.getTime(), intervalId)) {
                    return;
                }
            };
            tick();
            intervalId = setInterval(tick, 1000);
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialisePromotions);
    } else {
        initialisePromotions();
    }
})();
