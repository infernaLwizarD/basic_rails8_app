require 'morph'

class CustomResourceGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('templates', __dir__)

  argument :resource_label, type: :string, desc: 'Ресурс'

  class_option :skip_routes, type: :boolean, default: false, desc: 'Пропустить добавление роутов'
  class_option :skip_menu, type: :boolean, default: false, desc: 'Пропустить добавление в меню'

  def generate_migration
    migration_template 'migration.rb.tt', "db/migrate/#{migration_timestamp}_create_#{table_name}.rb"
  end

  def generate_model
    template 'model.rb.tt', "app/models/#{model_path}.rb"
  end

  def generate_repository
    template 'repository.rb.tt', "app/repositories/#{model_path}_repository.rb"
  end

  def generate_ransack
    template 'ransack.rb.tt', "app/models/concerns/#{model_path}_ransack.rb"
  end

  def generate_policy
    template 'policy.rb.tt', "app/policies/#{model_path}_policy.rb"
  end

  def generate_controller
    template 'controller.rb.tt', "app/controllers/web/#{controller_path}_controller.rb"
  end

  def generate_views
    template 'views/index.html.erb.tt', "app/views/web/#{controller_path}/index.html.erb"
    template 'views/show.html.erb.tt', "app/views/web/#{controller_path}/show.html.erb"
    template 'views/new.html.erb.tt', "app/views/web/#{controller_path}/new.html.erb"
    template 'views/edit.html.erb.tt', "app/views/web/#{controller_path}/edit.html.erb"
    template 'views/_form.html.erb.tt', "app/views/web/#{controller_path}/_form.html.erb"

    empty_directory "app/views/web/#{controller_path}/partials"
    template 'views/partials/_search_form.html.erb.tt',
             "app/views/web/#{controller_path}/partials/_search_form.html.erb"
  end

  def generate_factory
    template 'factory.rb.tt', "spec/factories/#{factory_path}.rb"
  end

  def generate_specs
    template 'specs/create_spec.rb.tt', "spec/features/#{controller_path}/create_spec.rb"
    template 'specs/update_spec.rb.tt', "spec/features/#{controller_path}/update_spec.rb"
    template 'specs/delete_spec.rb.tt', "spec/features/#{controller_path}/delete_spec.rb"
  end

  def print_instructions
    say "\n" + "=" * 80
    say "Генерация ресурса #{class_name} завершена!", :green
    say "=" * 80

    unless options[:skip_routes]
      say "\nДобавьте следующие роуты в config/routes.rb:", :yellow
      say route_instruction, :cyan
    end

    unless options[:skip_menu]
      say "\nДобавьте следующий пункт меню в app/views/layouts/lte/_sidebar_menu.html.erb:", :yellow
      say menu_instruction, :cyan
    end

    say "\nВыполните миграцию:", :yellow
    say "  rails db:migrate", :cyan

    say "\n" + "=" * 80 + "\n"
  end

  private

  # RAW UTF-8 для Morph/логики
  def resource_label_raw
    @resource_label_raw ||= to_utf8(resource_label.dup)
  end

  def to_utf8(string = '')
    string.force_encoding('UTF-8')
  end

  # solution for `next_migration_number': NotImplementedError
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  def migration_timestamp
    Time.now.utc.strftime('%Y%m%d%H%M%S')
  end

  def model_path
    class_name.underscore.gsub('::', '/')
  end

  def controller_path
    model_path.pluralize
  end

  def factory_path
    if namespace_parts.any?
      "#{namespace_parts.join('/')}/#{file_name.pluralize}"
    else
      file_name.pluralize
    end
  end

  def table_name
    class_name.underscore.gsub('::', '_').pluralize
  end

  def namespace_parts
    @namespace_parts ||= class_name.split('::')[0..-2].map(&:underscore)
  end

  def module_name
    namespace_parts.join('::').camelize
  end

  def resource_name
    file_name
  end

  def resource_class_name
    class_name.split('::').last
  end

  # Склонение ресурса (RAW: UTF-8)
  # Пример: input: "Бренд" → genitive_raw: "Бренда"
  def resource_label_genitive
    #puts "\n\n\nresource_label_genitive---",result.inspect,result.encoding.inspect,resource_label.encoding.inspect,resource_label_raw.encoding.inspect
    Morph.string(resource_label_raw, { imen: resource_label_raw, rod: nil }).rod rescue "#{resource_label_raw}а"
  end

  # Пример: input: "Бренд" → accusative_raw: "Бренд"
  def resource_label_accusative
    # result = Morph.string(resource_label_raw, { imen: resource_label_raw, vin: nil }).vin rescue resource_label_raw
    # String.new(result, encoding: 'UTF-8')
    #Morph.string(resource_label_raw, { imen: resource_label_raw, vin: nil }).vin rescue resource_label_raw

    Morph.string(resource_label_raw, { imen: resource_label_raw, vin: nil }).vin rescue resource_label_raw
  end

  # Пример: input: "Бренд" → plural_raw: "Бренды"
  def resource_label_plural
    # result = Morph.string(resource_label_raw, { imen: resource_label_raw, mnog_imen: nil }).mnog_imen rescue "#{resource_label_raw}ы"
    # String.new(result, encoding: 'UTF-8')
    Morph.string(resource_label_raw, { imen: resource_label_raw, mnog_imen: nil }).mnog_imen rescue "#{resource_label_raw}ы"
  end

  # Пример: input: "Бренд" → plural_genitive_raw: "Брендов"
  def resource_label_plural_genitive
    # result = Morph.string(resource_label_raw, { imen: resource_label_raw, mnog_rod: nil }).mnog_rod rescue "#{resource_label_raw}ов"
    # String.new(result, encoding: 'UTF-8')
    Morph.string(resource_label_raw, { imen: resource_label_raw, mnog_rod: nil }).mnog_rod rescue "#{resource_label_raw}ов"
  end

  # Вспомогательные методы для строк с кириллицей в шаблонах
  # Все возращают ASCII (HTML-энтити), безопасные для подстановки в .tt
  # Пример: input: "Бренд" → "Новый бренд" → "&#x41d;&#x43e;&#x432;&#x44b;&#x439; &#x431;&#x440;&#x435;&#x43d;&#x434;"
  def new_resource_title
    "Нов#{resource_label_genitive.match?(/[ая]$/) ? 'ая' : 'ый'} #{resource_label.downcase}"
  end

  # Пример: "Бренд успешно создан" → HTML-энтити
  def create_success_message
    "#{resource_label_raw} успешно создан#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  # Пример: "Бренд отредактирован" → HTML-энтити
  def update_success_message
    "#{resource_label_raw} отредактирован#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  # Пример: "Бренд удалён" → HTML-энтити
  def destroy_message
    "#{resource_label_raw} удалён#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  # Пример: "Бренд восстановлен" → HTML-энтити
  def restore_message
    "#{resource_label_raw} восстановлен#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  # Пример: "Бренд заблокирован" → HTML-энтити
  def lock_message
    "#{resource_label_raw} заблокирован#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  # Пример: "Бренд разблокирован" → HTML-энтити
  def unlock_message
    "#{resource_label_raw} разблокирован#{resource_label_genitive.match?(/[ая]$/) ? 'а' : ''}"
  end

  def route_name
    model_path.gsub('/', '_')
  end

  def route_path
    if namespace_parts.any?
      "#{namespace_parts.join('_')}_#{file_name.pluralize}"
    else
      file_name.pluralize
    end
  end

  def route_instruction
    # indent = namespace_parts.size * 2
    # base_indent = '  ' * 2  # базовый отступ для namespace :references внутри authenticated :user
    namespace_indent = '  ' * (2 + namespace_parts.size)

    routes = []

    if namespace_parts.any?
      namespace_parts.each_with_index do |part, index|
        current_indent = '  ' * (2 + index)
        routes << "#{current_indent}namespace :#{part} do"
      end
    end

    routes << "#{namespace_indent}# #{resource_label_plural}"
    routes << "#{namespace_indent}resources :#{file_name.pluralize} do"
    routes << "#{namespace_indent}  post 'restore', on: :member"
    routes << "#{namespace_indent}end"

    if namespace_parts.any?
      namespace_parts.size.times do |i|
        current_indent = '  ' * (2 + namespace_parts.size - i - 1)
        routes << "#{current_indent}end"
      end
    end

    "\n" + routes.join("\n")
  end

  def menu_instruction
    icon_name = 'file-alt'  # дефолтная иконка

    menu_code = <<~MENU
      <li class="nav-item">
        <%= ts_link_to(icon('nav-icon fas', '#{icon_name}', content_tag('p', '#{resource_label_plural}')),
                       #{route_path}_path,
                       class: 'nav-link align-items-center gap-1') %>
      </li>
    MENU

    "\n" + menu_code
  end


  # Преобразует строку в ASCII, заменяя не-ASCII на числовые HTML-энтити
  # Примеры:
  #  - "Бренд" → "&#x411;&#x440;&#x435;&#x43d;&#x434;"
  #  - "Новый бренд" → "&#x41d;&#x43e;&#x432;&#x44b;&#x439; &#x431;&#x440;&#x435;&#x43d;&#x434;"
  def to_html_escape_numeric(str)
    return '' if str.nil?
    s = to_utf8(str)
    s.each_codepoint.map { |cp| cp < 128 ? cp.chr : "&#x#{cp.to_s(16)};" }.join
  end

  # Возвращает Ruby-литерал строки с юникод-эскейпами (чистый ASCII на выходе)
  # Примеры:
  #  - "Бренда" → "\"\\u0411\\u0440\\u0435\\u043d\\u0434\\u0430\""
  #  - "Новый бренд" → "\"\\u041d\\u043e\\u0432\\u044b\\u0439 \\u0431\\u0440\\u0435\\u043d\\u0434\""
  def to_ruby_unicode_literal(str)
    return '' if str.nil?
    s = to_utf8(str)
    body = s.each_codepoint.map { |cp| cp < 128 ? cp.chr : "\\u#{cp.to_s(16).rjust(4, '0')}" }.join
    "\"#{body}\""
  end
end