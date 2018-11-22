FactoryBot.define do
  factory :restaurant do
    name { Faker::Lorem.word }
    location { Faker::Address.full_address }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    opening_hour '10:00h'
    closing_hour '02:00h'
  end
end