require 'rails_helper'

RSpec.describe 'Пользователь входит в систему', type: :system do
  before do
    visit root_path
  end

  context 'Администратор' do
    let(:user) { create(:user, :admin) }

    it 'входит в систему' do
      sign_in(login: user.username, password: user.password)
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end
  end

  context 'Зарегистрированный пользователь' do
    let(:user) { create(:user) }

    it 'входит в систему' do
      sign_in(login: user.username, password: user.password)
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end
  end

  context 'Незарегистрированный пользователь' do
    it 'входит в систему' do
      login = Faker::Internet.unique.username(separators: %w[_])
      password = Faker::Internet.unique.password(min_length: 6)
      sign_in(login:, password:)

      expect(page).to have_content 'Неверный Login или пароль'
    end
  end
end
