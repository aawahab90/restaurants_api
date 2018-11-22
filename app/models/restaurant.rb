class Restaurant < ApplicationRecord
  include PgSearch

  default_scope { where(archive: false) }

  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  has_many :reservations
  has_many :guests

  validates_presence_of :name, :phone, :location

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }


  pg_search_scope :search_by_name_and_location,
                  against: [[:name, 'A'], [:location, 'B']],
                  using: {
                    tsearch: { prefix: true, dictionary: :english }
                  }

  def self.search(filters)
    # search by query
    filters ||= {}
    scope = all
    scope = all.search_by_name_and_location(filters[:query]) if filters[:query].present?
    scope
  end
end
