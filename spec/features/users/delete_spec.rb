require 'rails_helper'

RSpec.shared_examples 'delete_self_profile' do
  it 'не может удалить свой профиль' do
    expect(page).to have_selector('#users-table')

    within('#users-table') do
      click_link(user.username)

      expect(page).to have_no_content('Удалить')
    end
  end
end

RSpec.describe 'Удаление пользователя', js: true, type: :system do
  before do
    logged_as(user)
    visit root_path

    within('.main-sidebar') do
      click_link('Пользователи')
    end
  end

  context 'Администратор' do
    let(:user) { create(:user, :admin) }

    let_it_be(:deleting_user) { create(:user, username: 'deleting_user') }
    let_it_be(:deleted_user) { create(:user, :discarded_user, username: 'deleted_user') }

    it 'удаляет пользователя' do
      expect(page).to have_selector('#users-table')

      within('#users-table') do
        expect(page).to have_content(deleting_user.username)
        click_link(deleting_user.username)
      end

      accept_confirm do
        click_on 'Удалить'
      end

      expect(page).to have_content 'Пользователь удалён'
    end

    it 'восстанавливает пользователя' do
      expect(page).to have_selector('#users-table')

      within('#users-table') do
        expect(page).to have_content(deleted_user.username)
        click_link(deleted_user.username)
      end

      click_on 'Восстановить'

      expect(page).to have_content 'Пользователь восстановлен'
    end

    it_behaves_like 'delete_self_profile'
  end

  context 'Обычный пользователь' do
    let(:user) { create(:user) }

    let_it_be(:some_user) { create(:user) }

    it 'не может удалять других пользователей' do
      expect(page).to have_selector('#users-table')

      within('#users-table') do
        expect(page).to have_content(some_user.username)
        click_link(some_user.username)
      end

      expect(page).to have_no_content('Удалить')
    end

    it_behaves_like 'delete_self_profile'
  end
end
