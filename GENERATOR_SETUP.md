# Установка и использование генератора custom_resource

## Установка

### 1. Установите зависимости

Примените предложенные изменения в `Gemfile` (добавлен gem 'morph'), затем выполните:

```bash
bundle install
```

### 2. Проверьте работу генератора

```bash
rails generate custom_resource --help
```

## Быстрый старт

### Пример: создание простого ресурса

```bash
rails generate custom_resource References::Brand 'Бренд'
```

Генератор создаст все необходимые файлы и выведет инструкции по:
- Добавлению роутов в `config/routes.rb`
- Добавлению пункта меню в `app/views/layouts/lte/_sidebar_menu.html.erb`

### После генерации

1. **Добавьте роуты** согласно инструкциям генератора
2. **Добавьте пункт меню** согласно инструкциям генератора
3. **Выполните миграцию:**
   ```bash
   rails db:migrate
   ```

## Структура генератора

```
lib/generators/custom_resource/
├── custom_resource_generator.rb          # Главный файл генератора
├── USAGE                                 # Краткое описание
├── README.md                             # Подробная документация
└── templates/                            # Шаблоны файлов
    ├── migration.rb.tt
    ├── model.rb.tt
    ├── repository.rb.tt
    ├── ransack.rb.tt
    ├── policy.rb.tt
    ├── controller.rb.tt
    ├── factory.rb.tt
    ├── views/
    │   ├── index.html.erb.tt
    │   ├── show.html.erb.tt
    │   ├── new.html.erb.tt
    │   ├── edit.html.erb.tt
    │   ├── _form.html.erb.tt
    │   └── partials/
    │       └── _search_form.html.erb.tt
    └── specs/
        ├── create_spec.rb.tt
        ├── update_spec.rb.tt
        └── delete_spec.rb.tt
```

## Примеры использования

### Ресурс с namespace

```bash
rails generate custom_resource References::ItemCategory 'Категория непродовольственных товаров'
rails generate custom_resource Catalog::Service 'Услуга'
```

### Простой ресурс без namespace

```bash
rails generate custom_resource Product 'Товар'
```

### С опциями

```bash
# Пропустить инструкции по роутам и меню
rails generate custom_resource References::Brand 'Бренд' --skip-routes --skip-menu
```

## Что генерируется

Для каждого ресурса создаются:

- ✅ Миграция базы данных
- ✅ Модель с валидациями
- ✅ Репозиторий со scope'ами
- ✅ Ransack модуль для поиска
- ✅ Политика с правами доступа
- ✅ Контроллер со всеми действиями
- ✅ Views (index, show, new, edit, form, search)
- ✅ Фабрика для тестов
- ✅ Feature тесты (create, update, delete)

## Дополнительная настройка

После генерации вы можете:

1. Добавить дополнительные поля в миграцию
2. Расширить модель ассоциациями
3. Настроить права доступа в политике
4. Кастомизировать views
5. Добавить дополнительные тесты

Подробнее см. `lib/generators/custom_resource/README.md`
