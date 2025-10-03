# lib/generators/support/resource_label_helper.rb
require 'morph'

module Support
  module ResourceLabelHelper
    def resource_label_raw
      @resource_label_raw ||= resource_label.dup.encode('UTF-8')
    end

    # Морфология (UTF-8)
    def resource_label_genitive
      Morph.string(resource_label_raw, { imen: resource_label_raw, rod: nil }).rod
    rescue StandardError
      "#{resource_label_raw}а"
    end

    def resource_label_accusative
      Morph.string(resource_label_raw, { imen: resource_label_raw, vin: nil }).vin
    rescue StandardError
      resource_label_raw
    end

    def resource_label_plural
      Morph.string(resource_label_raw,
                   { imen: resource_label_raw, mnog_imen: nil }).mnog_imen
    rescue StandardError
      "#{resource_label_raw}ы"
    end

    def resource_label_plural_genitive
      Morph.string(resource_label_raw,
                   { imen: resource_label_raw, mnog_rod: nil }).mnog_rod
    rescue StandardError
      "#{resource_label_raw}ов"
    end

    def new_resource_title
      adj = case resource_gender
            when :masc
              'Новый'
            when :fem
              'Новая'
            else
              'Новое'
            end
      "#{adj} #{resource_label_raw.downcase}"
    end

    def create_success_message
      "#{resource_label_raw} успешно создан#{gender_suffix}"
    end

    def update_success_message
      "#{resource_label_raw} отредактирован#{gender_suffix}"
    end

    def destroy_message
      "#{resource_label_raw} удалён#{gender_suffix}"
    end

    def restore_message
      "#{resource_label_raw} восстановлен#{gender_suffix}"
    end

    def lock_message
      "#{resource_label_raw} заблокирован#{gender_suffix}"
    end

    def unlock_message
      "#{resource_label_raw} разблокирован#{gender_suffix}"
    end

    private

    # Грубая, но рабочая эвристика по именительному падежу:
    def resource_gender
      name = resource_label_raw.to_s.downcase
      return :neut if name.end_with?('о', 'е', 'ё', 'мя')
      return :fem  if name.end_with?('а', 'я')

      :masc
    end

    def gender_suffix
      case resource_gender
      when :masc
        ''
      when :fem
        'а'
      else
        'о'
      end
    end
  end
end
