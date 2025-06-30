module PagyHelper
  # кастомный хелпер на основе pagy_bootstrap_nav (pagy/gem/lib/pagy/extras/bootstrap.rb) [pagy 9.3.4]
  def pagy_bootstrap_nav_custom(pagy, id: nil, classes: 'pagination pagination-sm mb-0', aria_label: nil, **vars)
    a = pagy_anchor(pagy, anchor_string: 'data-turbo-stream="true"', **vars)
    id_attr = id ? %( id="#{id}") : ''
    aria_attr = aria_label || pagy_t('pagy.aria_label.nav')

    html = %(<nav#{id_attr} class="pagy-bootstrap nav" aria-label="#{aria_attr}"><ul class="#{classes}">)

    # Кнопка "Назад"
    html << back_button(pagy, a)

    # Номера страниц и gap
    pagy.series(**vars).each do |item|
      html << case item
              when Integer
                %(<li class="page-item">#{a.call(item, classes: 'page-link')}</li>)
              when String
                %(<li class="page-item active">#{ts_link_to(
                  pagy.label_for(item),
                  '#',
                  class: 'page-link',
                  role: 'link',
                  'aria-current': 'page',
                  'aria-disabled': 'true'
                )}</li>)
              when :gap
                %(<li class="page-item gap disabled">#{ts_link_to(
                  pagy_t('pagy.gap'),
                  '#',
                  class: 'page-link',
                  role: 'link',
                  'aria-disabled': 'true'
                )}</li>)
              end
    end

    # Кнопка "Вперед"
    html << forward_button(pagy, a)

    html << %(</ul></nav>)
    html.html_safe
  end

  private

  def back_button(pagy, anchor)
    if pagy.prev
      %(<li class="page-item prev">#{anchor.call(
        pagy.prev,
        pagy_t('pagy.prev'),
        classes: 'page-link',
        aria_label: pagy_t('pagy.aria_label.prev')
      )}</li>)
    else
      %(<li class="page-item prev disabled">#{ts_link_to(
        pagy_t('pagy.prev'),
        '#',
        class: 'page-link',
        role: 'link',
        'aria-disabled': 'true',
        'aria-label': pagy_t('pagy.aria_label.prev')
      )}</li>)
    end
  end

  def forward_button(pagy, anchor)
    if pagy.next
      %(<li class="page-item next">#{anchor.call(
        pagy.next, pagy_t('pagy.next'),
        classes: 'page-link',
        aria_label: pagy_t('pagy.aria_label.next')
      )}</li>)
    else
      %(<li class="page-item next disabled">#{ts_link_to(
        pagy_t('pagy.next'),
        '#',
        class: 'page-link',
        role: 'link',
        'aria-disabled': 'true',
        'aria-label': pagy_t('pagy.aria_label.next')
      )}</li>)
    end
  end
end
