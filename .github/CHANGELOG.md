# Changelog

Все значимые изменения проекта документируются здесь.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/),
проект придерживается [Semantic Versioning](https://semver.org/lang/ru/).

## [Unreleased]

### Added
- README, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, SUPPORT
- GitHub Actions: CI (RSpec на Ruby 3.2/3.3) + Deploy (Render hook)
- Issue-шаблоны: bug_report, feature_request
- PR-шаблон, CODEOWNERS, FUNDING
- Ruleset для защиты `main`

## [1.0.0] — 2026-09-30

### Added
- Первый публичный релиз
- 15 городов, 3 статьи, 7 языков (ru, be, be-latn, en, uk, zh-Hans, zh-Hant)
- PWA: Service Worker, Manifest, offline-кэш
- RSS и Atom фиды
- Версия для слабовидящих (BVI)
- Sitemap.xml, robots.txt
- Sequel + SQLite, автомиграции при старте
- Sinatra-роутинг с fallback локали: URL → cookie → Accept-Language → ru
- Хостинг: Render (Web Service) + Cloudflare

[Unreleased]: https://github.com/NormikChel/bulbashlandia/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/NormikChel/bulbashlandia/releases/tag/v1.0.0