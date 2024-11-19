module UserRoleEnum
  extend ActiveSupport::Concern

  included do
    enum role: { admin: 'admin', user: 'user' }
  end

  ROLE_LABEL_BY_CODE = { 'admin' => 'Администратор', 'user' => 'Пользователь' }.freeze

  class_methods do
    def user_role_collection
      ROLE_LABEL_BY_CODE.keys.collect { |i| [ROLE_LABEL_BY_CODE[i], i] }
    end
  end

  def user_role_label
    ROLE_LABEL_BY_CODE.fetch(role, '')
  end
end
