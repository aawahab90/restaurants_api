module Validations
  extend ActiveSupport::Concern

  included do
    validates_presence_of :first_name, :last_name
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }


    def name
      [first_name, last_name].join(' ')
    end
  end
end
