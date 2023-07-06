# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    project
    name { Faker::Marketing.buzzwords }
    description { Faker::Lorem.sentence }
    association :assignee
    association :owner
  end
end
