require 'rails_helper'

RSpec.describe Reservation, type: :model do
  # Association test
  it { should belong_to(:restaurant) }
  it { should belong_to(:guest) }
  # Validation tests
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:covers) }
  it { should validate_presence_of(:guest_id) }
end
