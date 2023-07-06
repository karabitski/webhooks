# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  validates :name, :description, presence: true
end
