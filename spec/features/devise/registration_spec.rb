require 'rails_helper'

RSpec.describe 'Регистрация', type: :system do
  new_password = Faker::Internet.password(min_length: 6)

  before do
    visit root_path
  end

  context 'Зарегистрированный пользователь' do
    let(:user) { create(:user) }

    it 'проходит регистрацию' do
      click_on 'Регистрация'
      fill_in 'Имя пользователя', with: user.username
      fill_in 'Email', with: user.email
      fill_in 'Пароль', with: new_password
      fill_in 'Повторите пароль', with: new_password

      click_on 'Зарегистрироваться'
      expect(page).to have_content 'Username уже существует'
      expect(page).to have_content 'Email уже существует'
    end
  end

  context 'Незарегистрированный пользователь' do
    it 'проходит регистрацию и подтверждает учётную запись' do
      click_on 'Регистрация'
      fill_in 'Имя пользователя', with: Faker::Internet.unique.username(separators: %w[_])
      fill_in 'Email', with: Faker::Internet.unique.email
      fill_in 'Пароль', with: new_password
      fill_in 'Повторите пароль', with: new_password

      click_on 'Зарегистрироваться'
      expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')

      ctoken = last_email.body.match(/confirmation_token=[^"]*/)
      visit "/users/confirmation?#{ctoken}"

      expect(page).to have_content I18n.t('devise.confirmations.confirmed')
    end
  end
end
