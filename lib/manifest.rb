require 'json'

module Manifest
  def self.render(locale:, t:)
    name        = t.dig('meta', 'site_name')   || 'Бульбашляндия'
    description = t.dig('meta', 'description') || ''

    {
      name:             name,
      short_name:       name,
      description:      description,
      lang:             locale,
      dir:              'ltr',
      start_url:        "/#{locale}",
      scope:            '/',
      display:          'standalone',
      orientation:      'portrait-primary',
      theme_color:      '#0d0f12',
      background_color: '#f7f8fa',
      categories:       %w[travel education reference],
      icons: [
        { src: '/img/favicon/favicon-48x48.png',           sizes: '48x48',   type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/android-chrome-72x72.png',    sizes: '72x72',   type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/android-chrome-96x96.png',    sizes: '96x96',   type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/android-chrome-144x144.png',  sizes: '144x144', type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/android-chrome-192x192.png',  sizes: '192x192', type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/android-chrome-512x512.png',  sizes: '512x512', type: 'image/png', purpose: 'any' },
        { src: '/img/favicon/maskable-icon-192x192.png',   sizes: '192x192', type: 'image/png', purpose: 'maskable' },
        { src: '/img/favicon/maskable-icon-512x512.png',   sizes: '512x512', type: 'image/png', purpose: 'maskable' }
      ],
      shortcuts: [
        { name: t.dig('nav', 'cities'), url: "/#{locale}/cities" },
        { name: t.dig('nav', 'about'),  url: "/#{locale}/about"  }
      ]
    }.to_json
  end
end