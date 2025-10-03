module Support
  module PathHelper
    # Пример (References::Brand): "References::Brand" -> "references/brand"
    def model_path
      class_name.underscore
    end

    # Пример (References::Brand): "references/brand" -> "references/brands"
    def files_path
      model_path.pluralize
    end

    # Пример (References::Brand): "References"
    def module_name
      class_name.deconstantize
    end

    # Пример (References::Brand): "References::Brand" -> "Brand"
    def resource_class_name
      class_name.demodulize
    end

    # Пример (References::Brand): -> "brand"
    def resource_name
      resource_class_name.underscore
    end

    # Пример (References::Brand): "brand" -> "brands"
    def resource_name_plural
      resource_name.pluralize
    end

    # Пример (References::Brand): "References::Brand" -> ["references"]
    def namespace_parts
      mn = module_name
      mn.empty? ? [] : mn.underscore.split('/')
    end

    # Пример (References::Brand): "references/brand" -> "references_brand"
    def route_name
      model_path.tr('/', '_')
    end

    # Пример (References::Brand): -> "references_brands"
    def route_path
      route_name.pluralize
    end

    # Пример (References::Brand): -> "Web::References::BrandsController"
    def controller_class_name
      "Web::#{"#{module_name}::" if module_name.present?}#{resource_class_name.pluralize}Controller"
    end
  end
end
