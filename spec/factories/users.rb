FactoryBot.define do
  factory :owner, class: User do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    organization
    password { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :assignee, class: User do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    organization
    password { Faker::Internet.password }
  end
end
