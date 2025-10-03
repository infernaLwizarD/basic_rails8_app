require 'erb'

module Support
  class BaseGenerator < Rails::Generators::NamedBase
    include Rails::Generators::Migration

    no_tasks do
      def template_utf8(source, destination, &block)
        source_path = find_in_source_paths(source)
        content = File.read(source_path, encoding: 'UTF-8')
        erb = ERB.new(content, trim_mode: '-')
        result = erb.result(binding).encode('UTF-8')

        create_file destination, result, &block
      end
    end

    # Нумерация миграций
    # решение для `next_migration_number': NotImplementedError
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end
  end
end
