# frozen_string_literal: true

FactoryBot.define do
  factory :owner, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    organization
    password { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :assignee, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    organization
    password { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :user, class: 'User' do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    organization
    password { Faker::Internet.password }
  end
end
