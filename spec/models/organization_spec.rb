# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:tasks).through(:projects) }
  it { is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of(:name) }
end
