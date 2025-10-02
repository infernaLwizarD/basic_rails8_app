module FeatureHelpers
  def sign_in(options = {})
    visit new_user_session_path if options[:visit]
    fill_in 'Логин', with: options[:login]
    fill_in 'Пароль', with: options[:password]
    click_on 'Войти'
  end

  def logged_as(user)
    login_as(user, scope: :user)
  end

  # Навигация по пунктам меню
  # Пример: open_menu_links('Каталог', 'Продукция и услуги')
  def open_menu_links(*labels)
    path = labels.presence

    within('.sidebar-menu') do
      path.each { |label| click_link(label) }
    end
  end

  # Открывает запись со значением text в таблице с id table_id
  def open_from_table(table_id:, text:)
    expect(page).to have_selector("##{table_id}")

    within("##{table_id}") do
      expect(page).to have_content(text)
      click_link(text)
    end
  end
end
