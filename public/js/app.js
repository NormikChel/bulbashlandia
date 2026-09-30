(function () {
  'use strict';

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

  applyMode(getMode());

  try {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
      if (getMode() === 'system') applyMode('system');
    });
  } catch (e) { /* старые браузеры */ }

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

  // ---------- Кнопки темы ----------
  document.querySelectorAll('[data-theme-mode]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var mode = btn.dataset.themeMode;
      localStorage.setItem('theme', mode);
      applyMode(mode);
      closeAll(null);
    });
  });

  // ---------- BVI ----------
  if (window.isvek && document.querySelector('.bvi-open')) {
    var map = { ru: 'ru-RU', en: 'en-US', uk: 'ru-RU', be: 'ru-RU', 'be-latn': 'ru-RU' };
    var lang = map[root.lang] || 'ru-RU';
    try {
      window.bvi = new isvek.Bvi({ target: '.bvi-open', lang: lang });
    } catch (e) {
      console.warn('BVI init failed:', e);
    }
  }

  // ---------- Lenis (плавный скролл) ----------
  if (window.Lenis) {
    var lenis = new Lenis({ duration: 1.1, smoothWheel: true });
    function raf(time) {
      lenis.raf(time);
      requestAnimationFrame(raf);
    }
    requestAnimationFrame(raf);
  }

  // ---------- Service Worker ----------
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function () {
      navigator.serviceWorker
        .register('/sw.js', { scope: '/' })
        .catch(function (err) {
          console.warn('SW registration failed:', err);
        });
    });
  }
})();