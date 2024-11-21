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
end
