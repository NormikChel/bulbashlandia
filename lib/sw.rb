module ServiceWorker
  # На Render есть ENV['RENDER_GIT_COMMIT'] — используем как версию кэша.
  # Локально — timestamp старта.
  VERSION = (ENV['RENDER_GIT_COMMIT']&.slice(0, 7) || Time.now.to_i.to_s).freeze

  # Ядро: обязательно предзагрузить.
  PRECACHE = %w[
    /css/style.css
    /js/app.js
    /js/lenis.min.js
    /js/lenis-init.min.js
    /js/button-visually-impaired-javascript-master/dist/css/bvi.min.css
    /js/button-visually-impaired-javascript-master/dist/js/bvi.min.js
    /img/favicon/favicon.svg
    /img/favicon/favicon-32x32.png
    /img/favicon/favicon-16x16.png
    /img/favicon/apple-touch-icon.png
  ].freeze

  def self.render
    <<~JS
      /* Бульбашляндия — Service Worker
         Version: #{VERSION}
         Generated at: #{Time.now.utc.iso8601} */
      'use strict';

      const VERSION = #{VERSION.inspect};
      const CACHE   = 'bulbashlandia-' + VERSION;

      self.ASSETS = [
        #{PRECACHE.map(&:inspect).join(",\n  ")}
      ];

      self.__META_DATA__ = {
        version: VERSION,
        generated: #{Time.now.utc.iso8601.inspect}
      };

      // --- install: предзагрузка ядра ---
      self.addEventListener('install', (event) => {
        event.waitUntil(
          caches.open(CACHE)
            .then((cache) => cache.addAll(self.ASSETS))
            .then(() => self.skipWaiting())
        );
      });

      // --- activate: чистка старых кэшей ---
      self.addEventListener('activate', (event) => {
        event.waitUntil(
          caches.keys()
            .then((keys) => Promise.all(
              keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))
            ))
            .then(() => self.clients.claim())
        );
      });

      // --- fetch: HTML network-first, статика cache-first ---
      self.addEventListener('fetch', (event) => {
        const req = event.request;
        if (req.method !== 'GET') return;

        const url = new URL(req.url);
        if (url.origin !== self.location.origin) return;

        const accept  = req.headers.get('accept') || '';
        const isHTML  = accept.includes('text/html');

        if (isHTML) {
          event.respondWith(
            fetch(req)
              .then((res) => {
                const copy = res.clone();
                caches.open(CACHE).then((c) => c.put(req, copy)).catch(() => {});
                return res;
              })
              .catch(() => caches.match(req).then((r) => r || caches.match('/ru')))
          );
          return;
        }

        event.respondWith(
          caches.match(req).then((cached) => {
            if (cached) return cached;
            return fetch(req).then((res) => {
              if (res && res.ok) {
                const copy = res.clone();
                caches.open(CACHE).then((c) => c.put(req, copy)).catch(() => {});
              }
              return res;
            });
          })
        );
      });

      // --- сообщение для немедленного обновления ---
      self.addEventListener('message', (event) => {
        if (event.data === 'SKIP_WAITING') self.skipWaiting();
      });
    JS
  end
end