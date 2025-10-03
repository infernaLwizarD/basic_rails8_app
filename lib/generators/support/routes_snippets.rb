module Support
  module RoutesSnippets
    def route_instruction
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

      output = "\nДобавьте следующие роуты в config/routes.rb:".colorize(mode: :bold)
      output << "\n#{routes.join("\n")}".colorize(color: :black, background: :light_yellow)
    end

    def menu_instruction
      icon_name = 'file-alt'
      menu_code = <<~MENU
        <li class="nav-item">
          <%= ts_link_to(icon('nav-icon fas', '#{icon_name}', content_tag('p', '#{resource_label_plural}')),
                         #{route_path}_path,
                         class: 'nav-link align-items-center gap-1') %>
        </li>
      MENU

      output = "\nДобавьте следующий пункт меню в app/views/layouts/lte/_sidebar_menu.html.erb:".colorize(mode: :bold)
      output << "\n#{menu_code}".colorize(color: :black, background: :light_red)
    end
  end
end
