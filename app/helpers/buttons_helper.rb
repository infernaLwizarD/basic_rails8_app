module ButtonsHelper
  def lte_button_to(options)
    classes = %i[btn btn-sm]
    classes << (options[:bg_class].presence || 'btn-default')

    options[:text] ||= ''
    options[:path] ||= '#'

    if options[:method].present?
      ts_link_to(options[:text], options[:path], method: options[:method], class: classes.join(' ')).html_safe
    else
      ts_link_to(options[:text], options[:path], class: classes.join(' ')).html_safe
    end
  end

  def draw_edit_button(options)
    classes = %i[btn btn-sm btn-primary]
    classes << 'disabled' if options[:disabled].present?

    ts_link_to(icon('fas', 'edit', 'Редактировать'), options[:path], class: classes.join(' '))
  end

  def draw_back_button(options)
    classes = %i[btn btn-sm btn-secondary]
    classes << 'disabled' if options[:disabled].present?
    classes << options[:class].split(/\s+/) if options[:class].present?

    ts_link_to(icon('fas', 'arrow-left', 'Назад'), options[:path], class: classes.join(' '))
  end

  def draw_delete_button(options)
    classes = %i[btn btn-sm btn-danger]
    classes << 'disabled' if options[:disabled].present?

    options[:confirm_text] ||= 'Вы уверены?'
    ts_link_to(
      icon('fas', 'trash-alt', 'Удалить'),
      options[:path],
      data: { turbo_confirm: options[:confirm_text], turbo_method: :delete },
      class: classes.join(' ')
    )
  end

  def draw_save_button(options = {})
    # для кнопки за пределами формы необходимы параметры type="button", onclick="submit()", form="form_name"
    classes = %i[btn btn-sm border-0 btn-success]
    classes << 'disabled' if options[:disabled].present?

    options[:type] ||= 'submit'
    options[:name] ||= 'button'
    form = options[:form].present? ? %( form="#{options[:form]}") : ''
    id = options[:id].present? ? %( id="#{options[:id]}") : ''
    name = options[:name].present? ? %( name="#{options[:name]}") : ''
    onclick = options[:onclick].present? ? %( onclick="#{options[:onclick]}" ) : ''

    out = %(
      <button
        type="#{options[:type]}"
        class="#{classes.join(' ')}"#{form}#{id}#{name}#{onclick}>
        #{icon('fas', 'save', 'Сохранить')}
      </button>
    )
    out.html_safe
  end

  def draw_new_button(options)
    classes = %i[btn btn-sm]
    classes << 'disabled' if options[:disabled].present?

    classes << (options[:bg_class].presence || 'btn-outline-primary')

    class_prop = classes.join(' ')
    options[:label] ||= 'Добавить'
    options[:icon] ||= 'plus'

    if options[:button].present?
      %(
      #{ts_link_to(%(
          <button type="button" class="#{class_prop}">
            #{icon('fas', options[:icon], options[:label])}
          </button>
        ).html_safe, options[:path])}
      ).html_safe
    else
      ts_link_to(icon('fas', options[:icon], options[:label]), options[:path], class: class_prop)
    end
  end

  def draw_restore_button(options)
    classes = %i[btn btn-sm btn-warning]
    classes << 'disabled' if options[:disabled].present?
    classes << options[:class].split(/\s+/) if options[:class].present?

    ts_link_to(icon('fas', 'trash-restore', 'Восстановить'), options[:path], class: classes.join(' '),
                                                                             data: { turbo_method: :post })
  end
end
