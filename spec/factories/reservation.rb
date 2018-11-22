FactoryBot.define do
  factory :reservation do
    status 'approved'
    start_time { Faker::Time.forward(23, :evening) }
    covers { Faker::Number.between(1, 10) }
    note { Faker::Lorem.paragraph }
  end
end