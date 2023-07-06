# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :password_confirmation
      t.string :password_digest
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
