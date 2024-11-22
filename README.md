## README

Это базовое приложение на rails 8, которое включает в себя всё необходимое для начала разработки, что позволяет не тратить время на первоначальную установку и настройку ключевых компонентов. \
Для окружений development и production используются отдельные файлы конфигурации docker compose: docker-compose.development.yml и docker-compose.production.yml соответственно. Общие настройки для обоих сред находятся в файле docker-compose.yml.

Чтобы развернуть приложение необходимо выполнить следующие шаги:

- Клонируем репозиторий:
```bash
git clone git@github.com:infernaLwizarD/basic_rails8_app.git
```

- Переходим в директорию приложения и создаём файл с переменными окружения:
```bash
cd basic_rails8_app
cp .env.sample .env
```

- Собираем образы Docker:
 ```bash
docker compose build
 ```

- Создаем БД и заполняем её начальными данными:
 ```bash
docker compose run --rm web bundle exec rails db:prepare
 ```

- Запускаем приложение:
 ```bash
docker compose up
 ```

---
Запуск rubocop:
```bash
docker compose exec web rubocop -a
```
Запуск тестов:
```bash
docker compose exec web bash -c "RAILS_ENV=test rspec spec/features"
 ```