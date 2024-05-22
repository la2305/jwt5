class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,  :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts

  before_create :set_user_role

  ROLES =%w{super_admin admin user}

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  def set_user_role
    self.role = 'user'
  end
end
