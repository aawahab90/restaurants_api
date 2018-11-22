require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
  # Validation tests
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should_not allow_value("Inv4lid_@").for(:email) }
  it { should validate_presence_of(:password_digest) }
end