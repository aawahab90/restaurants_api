FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    role 'guest'
    password 'testrspec'
  end
end