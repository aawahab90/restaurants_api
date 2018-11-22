class Guest < ApplicationRecord
  include Validations
  has_many :reservations
  belongs_to :restaurant

  validates_presence_of :phone
end
