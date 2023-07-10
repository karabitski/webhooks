# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password validations: true
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  has_many :assignments, class_name: 'Task', foreign_key: :assignee_id, dependent: :nullify, inverse_of: :assignee
  has_many :tasks, foreign_key: :owner_id, dependent: :nullify, inverse_of: :owner
  belongs_to :organization
end
