FactoryBot.define do
  factory :comment do
    user { nil }
    post { nil }
    content { "MyString" }
  end
end
