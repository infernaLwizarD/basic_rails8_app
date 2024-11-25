require 'rails_helper'

RSpec.describe 'Восстановление пароля', type: :system do
  before do
    visit root_path
    click_on 'Забыли пароль?'
  end

  context 'Зарегистрированный пользователь' do
    let(:user) { create(:user) }

    it 'восстанавливает пароль' do
      fill_in 'Email', with: user.email
      click_on 'Отправить запрос'
      expect(page).to have_content I18n.t('devise.passwords.send_instructions')

      ptoken = last_email.body.match(/reset_password_token=[^"]*/)
      visit "users/password/edit?#{ptoken}"

      new_password = Faker::Internet.unique.password(min_length: 6)
      fill_in 'Новый пароль', with: new_password
      fill_in 'Повторите пароль', with: new_password
      click_on 'Изменить пароль'
      expect(page).to have_content I18n.t('devise.passwords.updated')
    end
  end

  context 'Незарегистрированный пользователь' do
    it 'восстанавливает пароль' do
      fill_in 'Email', with: Faker::Internet.unique.email
      click_on 'Отправить запрос'
      expect(page).to have_content 'Email не найден'
    end
  end
end
