FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(separators: %w[_]) }
    password { Faker::Internet.password(min_length: 6) }
    role { 'user' }
    created_at { 2.days.ago }
    confirmed_at { 1.day.ago }
    locked_at { nil }
    email { Faker::Internet.unique.email }

    trait :admin do
      role { 'admin' }
    end

    trait :discarded_user do
      discarded_at { 1.hour.ago }
    end

    trait :locked_user do
      locked_at { 1.hour.ago }
    end

    to_create { |instance| instance.save(validate: false) }
  end
end
