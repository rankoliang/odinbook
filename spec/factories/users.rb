FactoryBot.define do
  factory :user do
    email { 'foo@bar.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    confirmed_at { 1.year.ago }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
