require 'morph'
require 'erb'

require_relative '../support/base_generator'
require_relative '../support/resource_label_helper'
require_relative '../support/path_helper'
require_relative '../support/routes_snippets'

class CustomResourceGenerator < Support::BaseGenerator
  include Support::ResourceLabelHelper
  include Support::PathHelper
  include Support::RoutesSnippets

  source_root File.expand_path('templates', __dir__)

  argument :resource_label, type: :string, desc: 'Ресурс'

  class_option :skip_instructions, type: :boolean, default: false, desc: 'Пропустить инструкции'

  def generate_migration
    migration_template 'migration.rb.tt', "db/migrate/create_#{route_path}.rb"
  end

  def generate_model
    template_utf8 'model.rb.tt', "app/models/#{model_path}.rb"
  end

  def generate_repository
    template_utf8 'repository.rb.tt', "app/repositories/#{model_path}_repository.rb"
  end

  def generate_ransack
    template_utf8 'ransack.rb.tt', "app/models/concerns/#{model_path}_ransack.rb"
  end

  def generate_policy
    template_utf8 'policy.rb.tt', "app/policies/#{model_path}_policy.rb"
  end

  def generate_controller
    template_utf8 'controller.rb.tt', "app/controllers/web/#{files_path}_controller.rb"
  end

  def generate_views
    template_utf8 'views/index.html.erb.tt', "app/views/web/#{files_path}/index.html.erb"
    template_utf8 'views/show.html.erb.tt', "app/views/web/#{files_path}/show.html.erb"
    template_utf8 'views/new.html.erb.tt', "app/views/web/#{files_path}/new.html.erb"
    template_utf8 'views/edit.html.erb.tt', "app/views/web/#{files_path}/edit.html.erb"
    template_utf8 'views/_form.html.erb.tt', "app/views/web/#{files_path}/_form.html.erb"

    empty_directory "app/views/web/#{files_path}/partials"
    template_utf8 'views/partials/_search_form.html.erb.tt',
                  "app/views/web/#{files_path}/partials/_search_form.html.erb"
  end

  def generate_factory
    template_utf8 'factory.rb.tt', "spec/factories/#{files_path}.rb"
  end

  def generate_specs
    template_utf8 'specs/create_spec.rb.tt', "spec/features/#{files_path}/create_spec.rb"
    template_utf8 'specs/update_spec.rb.tt', "spec/features/#{files_path}/update_spec.rb"
    template_utf8 'specs/delete_spec.rb.tt', "spec/features/#{files_path}/delete_spec.rb"
  end

  def instructions
    puts "\nГенерация ресурса #{class_name} завершена!".colorize(color: :black, mode: :bold, background: :green)
    return if options[:skip_instructions].present?

    puts route_instruction
    puts menu_instruction
  end
end
