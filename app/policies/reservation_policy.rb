class ReservationPolicy < ApplicationPolicy

  def index?
    user.is_admin? || user.is_restaurant_user? || user.is_guest?
  end

  def read?
    user.is_admin? || user.is_restaurant_user? || user.is_guest?
  end

  def create?
    user.is_admin? || user.is_restaurant_user? || user.is_guest?
  end

  def update?
    user.is_admin? || user.is_restaurant_user? || user.is_guest?
  end

  def destroy?
    user.is_admin? || user.is_restaurant_user? || user.is_guest?
  end
end