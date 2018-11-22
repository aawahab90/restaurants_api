class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :guest

  validates_presence_of :status, :start_time, :covers, :guest_id
  validates :status, presence: true, inclusion: { in: ['pending', 'approved', 'cancel'] }

  def self.search(filters)
    # search by restaurant and guest emails
    filters ||= {}
    scope = all.joins(:guest).eager_load(:guest)
    scope = all.where('reservations.restaurant_id IN (?)', filters[:restaurant_ids]) if filters[:restaurant_ids].present?
    scope = all.where('guests.email IN (?)', filters[:guest_emails]) if filters[:guest_emails].present?
    scope
  end
end
