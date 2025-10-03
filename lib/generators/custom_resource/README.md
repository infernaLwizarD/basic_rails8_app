# Custom Resource Generator

Генератор для создания полноценного CRUD ресурса в Rails приложении с поддержкой namespace и склонения кириллических слов.

## Возможности

Генератор автоматически создаёт все необходимые файлы для работы ресурса:

- ✅ **Миграция** - создание таблицы с полями `label`, `discarded_at`, `timestamps` и связью `creator`
- ✅ **Модель** - с подключением Discard, Repository и Ransack модулей
- ✅ **Репозиторий** - со скоупами для фильтрации и сортировки
- ✅ **Ransack модуль** - для настройки поиска и фильтрации
- ✅ **Политика** - с правами доступа для admin_role
- ✅ **Контроллер** - со всеми стандартными действиями (index, show, new, create, edit, update, destroy, restore)
- ✅ **Views** - index, show, new, edit, форма и поисковая форма
- ✅ **Фабрика** - для тестирования с FactoryBot
- ✅ **Тесты** - feature тесты для create, update и delete

## Использование

### Базовая команда

```bash
rails generate custom_resource FooBar 'Наименование ресурса'
```

### Примеры

#### Простой ресурс без namespace

```bash
rails generate custom_resource Product 'Товар'
```

#### Ресурс с namespace

```bash
rails generate custom_resource References::ItemCategory 'Категория непродовольственных товаров'
```

```bash
rails generate custom_resource Catalog::Service 'Услуга'
```

### Опции

- `--skip-routes` - пропустить вывод инструкций по добавлению роутов
- `--skip-menu` - пропустить вывод инструкций по добавлению в меню

```bash
rails generate custom_resource References::Brand 'Бренд' --skip-routes --skip-menu
```

## Что генерируется

### Для ресурса `References::ItemCategory` с именем `'Категория непродовольственных товаров'`

**Миграция:**
```
db/migrate/[timestamp]_create_references_item_categories.rb
```

**Модель:**
```
app/models/references/item_category.rb
```

**Репозиторий:**
```
app/repositories/references/item_category_repository.rb
```

**Ransack модуль:**
```
app/models/concerns/references/item_category_ransack.rb
```

**Политика:**
```
app/policies/references/item_category_policy.rb
```

**Контроллер:**
```
app/controllers/web/references/item_categories_controller.rb
```

**Views:**
```
app/views/web/references/item_categories/
  ├── index.html.erb
  ├── show.html.erb
  ├── new.html.erb
  ├── edit.html.erb
  ├── _form.html.erb
  └── partials/
      └── _search_form.html.erb
```

**Фабрика:**
```
spec/factories/references/item_categories.rb
```

**Тесты:**
```
spec/features/references/item_categories/
  ├── create_spec.rb
  ├── update_spec.rb
  └── delete_spec.rb
```

## После генерации

После выполнения генератора вы получите инструкции по:

1. **Добавлению роутов** в `config/routes.rb`
2. **Добавлению пункта меню** в `app/views/layouts/lte/_sidebar_menu.html.erb`
3. **Выполнению миграции** - `rails db:migrate`

### Пример инструкций для роутов

```ruby
namespace :references do
  # Категории непродовольственных товаров
  resources :item_categories do
    post 'restore', on: :member
  end
end
```

### Пример инструкций для меню

```erb
<li class="nav-item">
  <%= ts_link_to(icon('nav-icon fas', 'file-alt', content_tag('p', 'Категории непродовольственных товаров')),
                 references_item_categories_path,
                 class: 'nav-link align-items-center gap-1') %>
</li>
```

## Склонение кириллических слов

Генератор автоматически склоняет кириллические наименования ресурсов с помощью gem `morph`:

- **Именительный падеж**: "Категория" → используется в заголовках
- **Родительный падеж**: "Категории" → используется в сообщениях ("Создание категории")
- **Винительный падеж**: "Категорию" → используется в действиях ("создаёт категорию")
- **Множественное число**: "Категории" → используется в меню и списках

## Структура модели

Генерируемая модель включает:

- `Discard::Model` - soft delete функционал
- `Repository` модуль для работы с данными
- `Ransack` модуль для поиска и фильтрации
- Связь `belongs_to :creator` - создатель записи
- Валидация `presence: true` для поля `label`

## Структура контроллера

Контроллер включает следующие действия:

- `index` - список ресурсов с поиском и пагинацией
- `show` - просмотр ресурса
- `new` - форма создания
- `create` - создание ресурса
- `edit` - форма редактирования
- `update` - обновление ресурса
- `destroy` - мягкое удаление (soft delete)
- `restore` - восстановление удалённого ресурса

## Зависимости

Генератор использует gem `morph` для склонения кириллических слов. Убедитесь, что он добавлен в `Gemfile`:

```ruby
gem 'morph'
```

## Примечания

- Генератор создаёт базовую структуру с полем `label`. Вы можете добавить дополнительные поля в миграцию после генерации.
- Все сгенерированные файлы следуют существующим паттернам проекта.
- Тесты используют FactoryBot и Capybara для system тестов.
- Политики настроены на проверку `admin_role?` - измените при необходимости.

## Customization

После генерации вы можете:

1. Добавить дополнительные поля в миграцию
2. Расширить модель дополнительными ассоциациями и валидациями
3. Добавить дополнительные scope'ы в репозиторий
4. Настроить ransackable атрибуты и ассоциации
5. Изменить права доступа в политике
6. Добавить дополнительные действия в контроллер
7. Кастомизировать views под свои нужды
