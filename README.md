# NeoMovies Web 🎬

> Современный веб-интерфейс для поиска и просмотра фильмов и сериалов

## 🚀 Особенности

- 🎭 **TMDB интеграция** - полная информация о фильмах и сериалах
- 🔍 **Умный поиск** - поиск по названию, актерам, жанрам
- 🎬 **Встроенные плееры** - просмотр через Alloha и Lumex
- 🧲 **Торрент интеграция** - поиск раздач по IMDB ID
- ⭐ **Система избранного** - сохраняйте любимые фильмы
- 🎨 **Современный UI** - адаптивный дизайн с темной темой
- 📱 **Мобильная версия** - оптимизировано для всех устройств
- 🔐 **JWT аутентификация** - безопасная авторизация
- 📧 **Email верификация** - подтверждение аккаунта

## 🛠 Технологии

- **Frontend**: Next.js 15, React 19, TypeScript
- **Styling**: Tailwind CSS, Radix UI
- **State Management**: Redux Toolkit
- **API**: Go API (neomovies-api)
- **Database**: MongoDB
- **Authentication**: JWT
- **Deployment**: Vercel

## 📦 Установка

1. **Клонируйте репозиторий:**
```bash
git clone https://github.com/Ernous/neomovies-web.git
cd neomovies-web
```

2. **Установите зависимости:**
```bash
npm install
```

3. Создайте файл `.env` и добавьте следующие переменные:
```env
NEXT_PUBLIC_API_URL=https://api.neomovies.ru
```

4. **Запустите проект:**
```bash
# Режим разработки
npm run dev

# Сборка для продакшена
npm run build
npm start
```
Приложение будет доступно по адресу [http://localhost:3000](http://localhost:3000)

## API (neomovies-api)

Приложение использует отдельный Go API сервер. API предоставляет следующие возможности:

- Поиск фильмов и сериалов через TMDB
- Получение детальной информации о фильме/сериале
- Поиск торрентов по IMDB ID с парсингом сезонов из названий
- Система избранного и реакций
- JWT аутентификация с email верификацией
- Оптимизированная загрузка изображений
- Кэширование запросов

### Особенности торрент-поиска

Новый API автоматически парсит сезоны из названий торрентов, что позволяет:
- Получать реальные доступные сезоны, а не только из TMDB
- Находить раздачи даже если нумерация сезонов отличается от официальной
- Группировать торренты по сезонам для удобного выбора

Backend `.env` пример смотрите в репозитории [neomovies-api](https://github.com/Ernous/neomovies-api).

---

## Структура проекта

```
neomovies-web/
├── src/
│   ├── app/            # App Router pages
│   ├── components/     # React компоненты
│   ├── hooks/          # React хуки
│   ├── lib/           # Утилиты и API
│   ├── types/         # TypeScript типы
│   └── styles/        # Глобальные стили
├── public/            # Статические файлы
└── package.json

```

## 👥 Авторы

- **Frontend Developer** - [Foxix](https://gitlab.com/foxixus)
- **Backend Developer** - [Ernous](https://github.com/Ernous)

## 📄 Лицензия

Этот проект распространяется под лицензией Apache-2.0. Подробности в файле [LICENSE](LICENSE).

## 🤝 Участие в проекте

Мы приветствуем любой вклад в развитие проекта! Если у вас есть предложения по улучшению:

1. Форкните репозиторий
2. Создайте ветку для ваших изменений
3. Внесите изменения
4. Отправьте pull request


## Благодарности

- [TMDB](https://www.themoviedb.org/) за предоставление API
- [Vercel](https://vercel.com/) за хостинг

## 📞 Контакты

Если у вас возникли вопросы или предложения, свяжитесь с нами:
- Email: neo.movies.mail@gmail.com
- Matrix: @foxixus:matrix.org

---

# ⚖ Юридическая информация / Legal Information

**NeoMovies** — это проект с открытым исходным кодом, целью которого является предоставление информации о фильмах и сериалах на основе TMDB. Мы **не храним**, **не распространяем** и **не размещаем** какие-либо видеоматериалы. Видеоконтент отображается через сторонние плееры, предоставляемые внешними балансерами, к которым сайт лишь предоставляет интерфейс доступа.

## 🛡️ Мы не несем ответственности

Мы не контролируем содержимое, предоставляемое сторонними плеерами. Все действия, связанные с просмотром или скачиванием контента, полностью лежат на пользователе.

Пользователи должны сами убедиться в соответствии использования сайта законодательству своей страны.

---

## 📚 Законодательство о защите авторских прав

Ниже приведены ссылки на законы и нормативные акты разных стран:

- 🇺🇸 [DMCA — Digital Millennium Copyright Act](https://www.copyright.gov/legislation/dmca.pdf) — США
- 🇪🇺 [Directive 2001/29/EC (InfoSoc)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32001L0029) — Европейский Союз
- 🇩🇪 [Urheberrechtsgesetz (UrhG)](https://www.gesetze-im-internet.de/urhg/) — Германия
- 🇫🇷 [Code de la propriété intellectuelle](https://www.legifrance.gouv.fr/codes/id/LEGITEXT000006069414/) — Франция
- 🇷🇺 [Гражданский кодекс РФ, часть IV](http://www.consultant.ru/document/cons_doc_LAW_64629/) — Россия
- 🇯🇵 [Japanese Copyright Act](https://www.cric.or.jp/english/clj/) — Япония
- 🌐 [WIPO Copyright Treaty](https://www.wipo.int/treaties/en/ip/wct/) — Всемирная организация интеллектуальной собственности

---

# ⚖ Legal Information (English)

**NeoMovies** is an open-source project that provides movie and TV show metadata using TMDB. We **do not host**, **store**, or **distribute** any video content. Media is streamed using third-party players served by external balancers, which we merely link to.

## 🛡️ Disclaimer of Liability

We do not control the content provided by external players. Any viewing or downloading of media is the user’s sole responsibility.

Users are advised to verify whether use of the site complies with their local copyright laws.

---

## 📚 Copyright Laws by Country

- 🇺🇸 [DMCA - U.S. Copyright Law](https://www.copyright.gov/legislation/dmca.pdf)
- 🇪🇺 [EU Directive 2001/29/EC](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32001L0029)
- 🇩🇪 [German Copyright Act (UrhG)](https://www.gesetze-im-internet.de/urhg/)
- 🇫🇷 [French Intellectual Property Code](https://www.legifrance.gouv.fr/codes/id/LEGITEXT000006069414/)
- 🇷🇺 [Russian Civil Code Part IV](http://www.consultant.ru/document/cons_doc_LAW_64629/)
- 🇯🇵 [Japanese Copyright Law](https://www.cric.or.jp/english/clj/)
- 🌐 [WIPO Copyright Treaty](https://www.wipo.int/treaties/en/ip/wct/)

---

<div align="center">
  <p>Made with ❤️ by Foxix</p>
</div>
