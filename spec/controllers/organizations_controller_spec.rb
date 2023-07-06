# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  describe 'GET #show' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }

    before do
      allow(controller).to receive(:find_user_by_token).and_return(user)
    end

    context 'when organization exists' do
      let(:expected_response) do
        {
          data: {
            id: organization.id.to_s,
            type: 'organization',
            attributes: {
              name: organization.name,
              created_at: organization.created_at.as_json
            }
          }
        }
      end

      it 'returns organization json' do
        get :show, params: { id: organization.id }

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when organization does not exist' do
      it 'returns 404' do
        get :show, params: { id: organization.id + 1 }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
