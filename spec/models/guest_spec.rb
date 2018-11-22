require 'rails_helper'

RSpec.describe Guest, type: :model do
  # Association test
  it { should have_many(:reservations) }
  it { should belong_to(:restaurant) }
  # Validation tests
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:email) }
  it { should_not allow_value("Inv4lid_@").for(:email) }
end
