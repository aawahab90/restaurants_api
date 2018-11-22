class UserPolicy < ApplicationPolicy

  def update_role?
    user.is_admin?
  end
end