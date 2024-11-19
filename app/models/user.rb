class User < ApplicationRecord
  include UserRoleEnum
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :trackable, :validatable,
         :rememberable, :lockable
end
