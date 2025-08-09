### README

Это базовое приложение на Rails 8, которое включает в себя всё необходимое для начала разработки, что позволяет не тратить время на первоначальную установку и настройку ключевых компонентов.

Для окружений development и production используются отдельные файлы конфигурации docker compose: docker-compose.development.yml и docker-compose.production.yml соответственно. Общие настройки для обеих сред находятся в файле docker-compose.yml. \
Bootstrap 5, AdminLTE 4 и Font Awesome 6 интегрированы вручную, т.к. гемы bootstrap и fontawesome тянут с собой устаревшие зависимости. В Rails 8 отказались от использования Sprockets в пользу Propshaft, поэтому не рекомендуется использовать гемы, которые зависят от sassc.

Чтобы развернуть приложение необходимо выполнить следующие шаги:

- Клонируем репозиторий:
```bash
git clone git@github.com:infernaLwizarD/basic_rails8_app.git
```

- Переходим в директорию приложения и создаём файлы с переменными окружения:
```bash
cd basic_rails8_app
cp .env.sample .env
cp .env.kamal.sample .env.kamal
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

---

Для запуска приложения локально в режиме production достаточно раскомментировать соответствующую секцию с переменными в .env и сделать ребилд (`docker compose build`)

---

Деплой осуществляется при помощи kamal из специального контейнера для деплоя. Так сделано чтобы не было зависимости от среды запуска деплоя.
Сборка образа:
```bash
docker build -f Dockerfile.kamal -t basic-rails-8-kamal .
```
Перед деплоем при помощи kamal необходимо запустить установочный скрипт install-kamal-function.sh, который автоматически добавит wrapper функцию kamal в ~/.bashrc.
### Справка по использованию install-kamal-function.sh

**Установка функции:**

```bash
./install-kamal-function.sh
# или
./install-kamal-function.sh install
```

**Удаление функции:**
```bash
./install-kamal-function.sh uninstall
```

**Показать справку по командам скрипта:**
```bash
./install-kamal-function.sh --help
```

### Подготовка VPS сервера

Подключитесь к серверу и выполните:
```bash
# Обновление системы
sudo apt update && sudo apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Добавление пользователя в группу docker
sudo usermod -aG docker $USER

# Перезапуск сессии
exit
# Подключитесь заново по SSH

# Проверка Docker
docker --version
docker run hello-world
```
**Настройте SSH ключи:**
```bash
# Создайте SSH ключ если его нет
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Скопируйте публичный ключ на сервер
ssh-copy-id user@YOUR_SERVER_IP

# Проверьте подключение
ssh user@YOUR_SERVER_IP
```
---
<details>
  <summary style="font-size: large; font-weight: bold;">Справка по основным командам Kamal</summary>

### Основные команды развертывания

#### Первоначальное развертывание
```bash
kamal setup           # Первоначальная настройка серверов и развертывание
kamal deploy          # Развертывание приложения (после setup)
```

#### Управление приложением
```bash
kamal app start       # Запустить приложение
kamal app stop        # Остановить приложение
kamal app restart     # Перезапустить приложение
kamal app exec "cmd"  # Выполнить команду в контейнере приложения
kamal app logs        # Показать логи приложения
kamal app logs -f     # Следить за логами в реальном времени
kamal app version     # Показать версию развернутого приложения
```

#### Консоль и отладка
```bash
kamal app exec -i bash              # Интерактивная bash-сессия в контейнере
kamal app exec "rails console"      # Rails консоль
kamal app exec "rails db:migrate"   # Выполнить миграции
kamal console                       # Интерактивная консоль (alias для exec -i bash)
```

#### Управление аксессуарами (базы данных, Redis и т.д.)
```bash
kamal accessory start redis         # Запустить Redis
kamal accessory stop redis          # Остановить Redis
kamal accessory restart redis       # Перезапустить Redis
kamal accessory logs redis          # Логи Redis
kamal accessory exec redis "cmd"    # Выполнить команду в Redis контейнере

kamal accessory start db            # Запустить базу данных
kamal accessory logs db             # Логи базы данных
```

#### Информация о состоянии
```bash
kamal details         # Подробная информация о развертывании
kamal audit           # История развертываний
kamal config          # Показать конфигурацию
kamal version         # Версия Kamal
```

#### Управление образами Docker
```bash
kamal build           # Собрать Docker образ
kamal build push      # Собрать и загрузить образ в registry
kamal registry login  # Войти в Docker registry
```

#### Управление серверами
```bash
kamal server bootstrap            # Установить Docker на серверы
kamal server exec "command"       # Выполнить команду на всех серверах
kamal server exec -r web "cmd"    # Выполнить команду на серверах роли 'web'
```

#### Откат версий
```bash
kamal rollback        # Откатиться к предыдущей версии
kamal rollback v1.2.3 # Откатиться к конкретной версии
```

#### Очистка и обслуживание
```bash
kamal prune all       # Удалить неиспользуемые образы и контейнеры
kamal prune images    # Удалить старые образы
kamal prune containers # Удалить остановленные контейнеры
```

#### Мониторинг и траблшутинг
```bash
kamal traefik logs    # Логи Traefik (если используется)
kamal traefik reload  # Перезагрузить конфигурацию Traefik

kamal server exec "docker ps" # Показать запущенные контейнеры
kamal server exec "docker ps -a" # Показать все контейнеры (включая остановленные)
kamal server exec "docker images" # Показать список образов на сервере
kamal server exec "docker volume ls" # Показать список volumes на сервере
```

#### SSL/TLS сертификаты
```bash
kamal traefik boot           # Запустить Traefik
kamal traefik reboot         # Перезапустить Traefik
kamal accessory boot letsencrypt  # Настроить Let's Encrypt (если сконфигурировано)
```

### Полезные комбинации команд

#### Полное обновление приложения
```bash
kamal build push && kamal deploy
```

#### Быстрая проверка состояния
```bash
kamal details && kamal app logs --lines 50
```

#### Отладка проблем с подключением
```bash
kamal server exec "docker ps -a"
kamal app logs --lines 100
kamal accessory logs db --lines 50
```

#### Обновление конфигурации без пересборки
```bash
kamal deploy --skip-push
```

### Переменные окружения

Kamal считывает переменные из `.env` файлов:
- `.env` - по-умолчанию основные переменные считываются отсюда
- `.env.erb` - можно создать переменные с ERB шаблонами
- Переменные можно передавать через `--env-file`. Как раз таким образом в данном приложении kamal считывает их из специального файла `--env-file .env.kamal`

### Файлы конфигурации

- `config/deploy.yml` - основная конфигурация Kamal
- `.kamalignore` - файлы для исключения из Docker контекста
- `Dockerfile.production` - инструкции для сборки образа приложения

### Примеры использования

```bash
# Полное развертывание с нуля
kamal setup

# Обновление кода приложения
git pull
kamal deploy

# Выполнение миграций
kamal app exec "rails db:migrate"

# Просмотр логов в реальном времени
kamal app logs -f

# Подключение к Rails консоли
kamal app exec -i "rails console"

# Перезапуск только приложения (без базы данных)
kamal app restart

# Откат к предыдущей версии при проблемах
kamal rollback
```

### Дополнительные опции

Большинство команд поддерживают дополнительные флаги:
- `--version=X.X.X` - указать конкретную версию
- `--hosts=server1,server2` - выполнить только на указанных серверах
- `--roles=web,worker` - выполнить только для указанных ролей
- `--dry-run` - показать что будет выполнено без реального выполнения
- `--verbose` - подробный вывод

Для получения справки по любой команде используйте:
```bash
kamal COMMAND --help
```

</details>

---