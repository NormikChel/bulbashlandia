(function () {
  'use strict';

  // ---------- Service Worker (самое первое, критично для PWA) ----------
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker
      .register('/sw.js', { scope: '/' })
      .catch(function (err) {
        console.warn('SW registration failed:', err);
      });
  }

  // ---------- Тема ----------
  var root = document.documentElement;

  function getMode() {
    return localStorage.getItem('theme') || 'system';
  }

  function applyMode(mode) {
    root.dataset.themeMode = mode;
    var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    var dark = mode === 'dark' || (mode === 'system' && prefersDark);
    root.dataset.theme = dark ? 'dark' : 'light';
  }

  try {
    applyMode(getMode());
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
      if (getMode() === 'system') applyMode('system');
    });
  } catch (e) { console.warn('theme:', e); }

  // ---------- Дропдауны (тема + язык) ----------
  function closeAll(except) {
    document.querySelectorAll('.switcher[data-open="true"]').forEach(function (el) {
      if (el !== except) {
        el.dataset.open = 'false';
        var t = el.querySelector('.switcher-toggle');
        if (t) t.setAttribute('aria-expanded', 'false');
      }
    });
  }

  try {
    document.querySelectorAll('.switcher').forEach(function (switcher) {
      var toggle = switcher.querySelector('.switcher-toggle');
      if (!toggle) return;

      toggle.addEventListener('click', function (e) {
        e.stopPropagation();
        e.preventDefault();
        var willOpen = switcher.dataset.open !== 'true';
        closeAll(switcher);
        switcher.dataset.open = willOpen ? 'true' : 'false';
        toggle.setAttribute('aria-expanded', String(willOpen));
      });
    });

    document.addEventListener('click', function () { closeAll(null); });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeAll(null);
    });

    document.querySelectorAll('[data-theme-mode]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        var mode = btn.dataset.themeMode;
        localStorage.setItem('theme', mode);
        applyMode(mode);
        closeAll(null);
      });
    });
  } catch (e) { console.warn('switchers:', e); }

  // ---------- BVI ----------
  try {
    if (window.isvek && document.querySelector('.bvi-open')) {
      var map = { ru: 'ru-RU', en: 'en-US', uk: 'ru-RU', be: 'ru-RU', 'be-latn': 'ru-RU' };
      var lang = map[root.lang] || 'ru-RU';
      window.bvi = new isvek.Bvi({ target: '.bvi-open', lang: lang });
    }
  } catch (e) { console.warn('BVI init failed:', e); }

  // Lenis уже инициализируется в lenis-init.min.js:
  //   window.lenisInstance = new Lenis({ autoRaf: true, ... })
  // Дублировать не нужно. Если захочешь управлять им из кода — используй window.lenisInstance.
})();