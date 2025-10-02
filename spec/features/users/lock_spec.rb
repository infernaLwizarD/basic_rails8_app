require 'rails_helper'

RSpec.shared_examples 'lock_self_profile' do
  it 'не может заблокировать свой профиль' do
    open_from_table(table_id: 'users-table', text: user.username)

    expect(page).to have_no_content('Заблокировать')
  end
end

RSpec.describe 'Блокировка пользователя', js: true, type: :system do
  before do
    logged_as(user)
    visit root_path

    open_menu_links('Пользователи')
  end

  context 'Администратор' do
    let(:user) { create(:user, :admin) }

    let_it_be(:locking_user) { create(:user) }
    let_it_be(:locked_user) { create(:user, :locked_user) }

    it 'проверка создания пользователей' do
      expect(User.exists?(username: locking_user.username)).to be(true)
      expect(User.exists?(username: locked_user.username)).to be(true)
    end

    it 'блокирует пользователя' do
      open_from_table(table_id: 'users-table', text: locking_user.username)

      click_on 'Заблокировать'

      expect(page).to have_content 'Пользователь заблокирован'
    end

    it 'восстанавливает пользователя' do
      open_from_table(table_id: 'users-table', text: locked_user.username)

      click_on 'Разблокировать'

      expect(page).to have_content 'Пользователь разблокирован'
    end

    it_behaves_like 'lock_self_profile'
  end

  context 'Обычный пользователь' do
    let(:user) { create(:user) }

    let_it_be(:some_user) { create(:user) }

    it 'проверка создания пользователя' do
      expect(User.exists?(username: some_user.username)).to be(true)
    end

    it 'не может заблокировать других пользователей' do
      open_from_table(table_id: 'users-table', text: some_user.username)
      expect(page).to have_no_content('Заблокировать')
    end

    it_behaves_like 'lock_self_profile'
  end
end
