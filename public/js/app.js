(function () {
  // ---------- Тема ----------
  const root = document.documentElement;
  const mode = () => localStorage.getItem('theme') || 'system';

  const apply = (m) => {
    root.dataset.themeMode = m;
    const dark = m === 'dark' || (m === 'system' && matchMedia('(prefers-color-scheme: dark)').matches);
    root.dataset.theme = dark ? 'dark' : 'light';
  };

  apply(mode());

  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    if (mode() === 'system') apply('system');
  });

  document.querySelectorAll('[data-theme-mode]').forEach((btn) => {
    btn.addEventListener('click', () => {
      const m = btn.dataset.themeMode;
      localStorage.setItem('theme', m);
      apply(m);
      closeAll();
    });
  });

  // ---------- Открытие/закрытие меню ----------
  const closeAll = () => document.querySelectorAll('[data-open]').forEach((el) => el.dataset.open = 'false');

  document.querySelectorAll('.lang-toggle, .theme-toggle').forEach((toggle) => {
    toggle.addEventListener('click', (e) => {
      e.stopPropagation();
      const parent = toggle.closest('[data-open]');
      const isOpen = parent.dataset.open === 'true';
      closeAll();
      parent.dataset.open = isOpen ? 'false' : 'true';
      toggle.setAttribute('aria-expanded', String(!isOpen));
    });
  });

  document.addEventListener('click', closeAll);
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeAll(); });

  // ---------- BVI ----------
  if (window.isvek && document.querySelector('.bvi-open')) {
    const map = { ru: 'ru-RU', en: 'en-US', uk: 'ru-RU', be: 'ru-RU', 'be-latn': 'ru-RU' };
    const lang = map[root.lang] || 'ru-RU';
    window.bvi = new isvek.Bvi({ target: '.bvi-open', lang });
  }

  // ---------- Lenis ----------
  if (window.Lenis) {
    const lenis = new Lenis({ duration: 1.1, smoothWheel: true });
    const raf = (t) => { lenis.raf(t); requestAnimationFrame(raf); };
    requestAnimationFrame(raf);
  }
})();