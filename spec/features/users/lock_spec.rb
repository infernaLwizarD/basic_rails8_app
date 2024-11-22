require 'rails_helper'

RSpec.shared_examples 'lock_self_profile' do
  it 'не может заблокировать свой профиль' do
    within('#users-table') do
      expect(page).to have_content(user.username)
      click_link(user.username)
    end

    expect(page).not_to have_content 'Заблокировать'
  end
end

RSpec.describe 'Блокировка пользователя', js: true, type: :system do
  before do
    logged_as(user)
    visit root_path

    within('.main-sidebar') do
      click_link('Пользователи')
    end
  end

  context 'Администратор' do
    let(:user) { create(:user, :admin) }

    let!(:locking_user) { create(:user) }
    let!(:locked_user) { create(:user, :locked_user) }

    it 'блокирует пользователя' do
      within('#users-table') do
        expect(page).to have_content(locking_user.username)
        click_link(locking_user.username)
      end

      click_on 'Заблокировать'

      expect(page).to have_content 'Пользователь заблокирован'
    end

    it 'восстанавливает пользователя' do
      within('#users-table') do
        expect(page).to have_content(locked_user.username)
        click_link(locked_user.username)
      end

      click_on 'Разблокировать'

      expect(page).to have_content 'Пользователь разблокирован'
    end

    include_examples 'lock_self_profile'
  end

  context 'Обычный пользователь' do
    let(:user) { create(:user) }

    let!(:some_user) { create(:user) }

    it 'не может заблокировать других пользователей' do
      within('#users-table') do
        expect(page).to have_content(some_user.username)
        click_link(some_user.username)
      end
      expect(page).not_to have_content 'Заблокировать'
    end

    include_examples 'lock_self_profile'
  end
end
