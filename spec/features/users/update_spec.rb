require 'rails_helper'

RSpec.shared_examples 'edit_user' do
  it 'успешно редактирует' do
    expect(page).to have_selector('#users-table')

    within('#users-table') do
      expect(page).to have_content(edited_user.username)
      click_link(edited_user.username)
    end

    click_on 'Редактировать'

    new_name = Faker::Internet.unique.username(separators: %w[_])
    fill_in 'Имя пользователя', with: new_name

    click_on 'Сохранить'

    expect(page).to have_content 'Пользователь отредактирован'
    expect(page).to have_content new_name
  end

  it 'получает сообщение об ошибке не заполнив обязательных полей' do
    expect(page).to have_selector('#users-table')

    within('#users-table') do
      expect(page).to have_content(edited_user.username)
      click_link(edited_user.username)
    end

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

    within('.sidebar-menu') do
      click_link('Пользователи')
    end
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
      expect(page).to have_selector('#users-table')

      within('#users-table') do
        expect(page).to have_content(some_user.username)
        click_link(some_user.username)
      end

      expect(page).to have_no_content('Редактировать')
    end

    context 'свой профиль' do
      let(:edited_user) { user }

      it_behaves_like 'edit_user'
    end
  end
end
