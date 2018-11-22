class User < ApplicationRecord
  include Validations

  ROLES = ['admin',
           'restaurant_user',
           'guest'].freeze

  # encrypt password
  has_secure_password

  # Validations
  validates_presence_of :password_digest
  validates_uniqueness_of :email
  validates :role, presence: true, inclusion: { in: ROLES }

  def is_admin?
    role == 'admin'
  end

  def is_restaurant_user?
    role == 'restaurant_user'
  end

  def is_guest?
    role == 'guest'
  end
end
