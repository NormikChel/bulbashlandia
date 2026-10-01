# 🥔 Бульбашляндия

> Независимый мультиязычный сайт о Беларуси — города, история, культура, кухня и природа в одном месте.

[![Ruby](https://img.shields.io/badge/Ruby-3.x-CC342D?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Sinatra](https://img.shields.io/badge/Sinatra-4.x-000000?logo=ruby-sinatra)](http://sinatrarb.com/)
[![Sequel](https://img.shields.io/badge/Sequel-5.x-8B0000)](https://sequel.jeremyevans.net/)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

**🌐 Live:** [bulbashlandia.onrender.com](https://bulbashlandia.onrender.com/ru)

---

## ✨ Что внутри

- 🏙 **15 городов** — от Минска до Лиды
- 📜 **История** — Полоцкое княжество, ВКЛ, Речь Посполитая, XX век
- 🍲 **Кухня** — драники, бабка, колдуны
- 🌲 **Природа** — Беловежская пуща, Нарочь, Браславские озёра
- 🌍 **7 языков** — ru, be, be-latn, en, uk, zh-Hans, zh-Hant
- 📱 **PWA** — офлайн-кэш, установка на телефон
- 📡 **RSS + Atom** — фиды для каждого языка

## 🛠 Стек

| Слой | Технология |
|------|-----------|
| Язык | Ruby |
| Фреймворк | Sinatra |
| ORM | Sequel |
| БД | SQLite |
| Шаблоны | ERB |
| Стили | SCSS → CSS |
| Фронтенд | Vanilla JS (Lenis, BVI) |
| PWA | Service Worker + Manifest |
| Хостинг | Render + Cloudflare |

## 🚀 Запуск локально

```bash
git clone https://github.com/NormikChel/bulbashlandia.git
cd bulbashlandia
bundle install
ruby app.rb
# → http://localhost:3000
```

## 📁 Структура

```
app.rb           # главный файл Sinatra
config.ru        # Rack-конфиг
lib/             # i18n, rss, atom, sw, manifest
models/          # Sequel-модели (City, Article)
views/           # ERB-шаблоны
i18n/            # YAML-словари (7 языков)
db/              # миграции + SQLite
public/          # статика (css, js, img)
spec/            # тесты
```

## 📡 Ленты

- RSS: [/ru/rss.xml](https://bulbashlandia.onrender.com/ru/rss.xml)
- Atom: [/ru/atom.xml](https://bulbashlandia.onrender.com/ru/atom.xml)

## 📜 Лицензия

- **Код** — [MIT](LICENSE)
- **Контент** (тексты, статьи, описания городов, словари) — [CC BY-SA 4.0](LICENSE-CONTENT)

---

Сделано с ❤️ к Беларуси.
