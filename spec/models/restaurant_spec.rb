require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  # Association test
  it { should have_many(:reservations) }
  it { should have_many(:guests) }
  it { should belong_to(:created_by) }
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:email) }
  it { should_not allow_value("Inv4lid_@").for(:email) }
end
