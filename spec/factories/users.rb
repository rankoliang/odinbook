FactoryBot.define do
  factory :user do
    email { 'foo@bar.com' }
    name { 'foobar' }
    password { 'foobar' }
    password_confirmation { 'foobar' }

    transient do
      confirmed { true }
    end

    after :create do |user, options|
      user.confirm if options.confirmed
    end
  end
end
