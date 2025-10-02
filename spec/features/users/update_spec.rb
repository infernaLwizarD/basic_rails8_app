require 'rails_helper'

RSpec.shared_examples 'edit_user' do
  it 'успешно редактирует' do
    open_from_table(table_id: 'users-table', text: edited_user.username)

    click_on 'Редактировать'

    new_name = Faker::Internet.unique.username(separators: %w[_])
    fill_in 'Имя пользователя', with: new_name

    click_on 'Сохранить'

    expect(page).to have_content 'Пользователь отредактирован'
    expect(page).to have_content new_name
  end

  it 'получает сообщение об ошибке не заполнив обязательных полей' do
    open_from_table(table_id: 'users-table', text: edited_user.username)

    click_on 'Редактировать'

    fill_in 'Имя пользователя', with: ''

    click_on 'Сохранить'

    expect(page).to have_content 'не может быть пустым'
  end
end

RSpec.describe 'Редактирование пользователя', js: true, type: :system do
  before do
    logged_as(user)
    visit root_path

    open_menu_links('Пользователи')
  end

  context 'Администратор' do
    let(:user) { create(:user, :admin) }

    let_it_be(:some_user) { create(:user) }

    context 'свой профиль' do
      let(:edited_user) { user }

      it_behaves_like 'edit_user'
    end

    context 'профиль другого пользователя' do
      let(:edited_user) { some_user }

      it_behaves_like 'edit_user'
    end
  end

  context 'Обычный пользователь' do
    let(:user) { create(:user) }

    let_it_be(:some_user) { create(:user) }

    it 'не может добавлять и редактировать других пользователей' do
      expect(page).to have_no_content('Добавить')
      open_from_table(table_id: 'users-table', text: some_user.username)

      expect(page).to have_no_content('Редактировать')
    end

    context 'свой профиль' do
      let(:edited_user) { user }

      it_behaves_like 'edit_user'
    end
  end
end
