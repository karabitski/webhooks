# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    allow(controller).to receive(:find_user_by_token).and_return(user)
  end

  describe 'GET #index' do
    let!(:organization1) { create(:organization) }
    let(:user) { create(:user, organization: organization1) }
    let!(:project1) { create(:project, organization: organization1) }
    let(:expected_response) do
      {
        data: [{
          id: project1.id.to_s,
          type: 'project',
          attributes: {
            name: project1.name,
            organization_id: organization1.id,
            created_at: project1.created_at.as_json,
            updated_at: project1.updated_at.as_json
          }
        }]
      }
    end

    it 'returns all projects for organization' do
      get :index, params: { organization_id: organization1.id }

      expect(response).to be_ok
      expect(json_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    let(:project) { Project.order(id: :desc).first }
    let(:expected_response) do
      {
        data: {
          id: project.id.to_s,
          type: 'project',
          attributes: {
            name: 'Test Name',
            organization_id: organization.id,
            created_at: Time.zone.now.as_json,
            updated_at: Time.zone.now.as_json
          }
        }
      }
    end

    context 'when successfully created' do
      it 'returns project json' do
        freeze_time do
          post :create, params: { organization_id: organization.id, name: 'Test Name' }

          expect(response).to be_ok
          expect(json_response).to eq(expected_response)
        end
      end
    end

    context 'when error occurred' do
      it 'returns errors' do
        post :create, params: { organization_id: organization.id }

        expect(response.status).to eq(422)
        expect(json_response).to eq(errors: ["Name can't be blank"])
      end
    end
  end

  describe 'GET #show' do
    context 'when project exists' do
      let(:project) { create(:project) }
      let(:params) { { organization_id: project.organization_id, id: project.id } }
      let(:user) { create(:user, organization: project.organization) }
      let(:expected_response) do
        {
          data: {
            id: project.id.to_s,
            type: 'project',
            attributes: {
              name: project.name,
              organization_id: project.organization_id,
              created_at: project.created_at.as_json,
              updated_at: project.updated_at.as_json
            }
          }
        }
      end

      it 'returns project json' do
        get :show, params: params

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }

      it 'returns 404' do
        get :show, params: { organization_id: organization.id, id: 1 }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }
      let(:user) { create(:user, organization: organization1) }

      it 'returns 404' do
        get :show, params: { organization_id: organization1.id, id: project2.id }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when project exists' do
      let(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }

      context 'when successfully updated' do
        let(:params) do
          {
            organization_id: project.organization_id,
            id: project.id,
            name: 'Random Test Name'
          }
        end
        let(:expected_response) do
          {
            data: {
              id: project.id.to_s,
              type: 'project',
              attributes: {
                name: 'Random Test Name',
                organization_id: project.organization_id,
                created_at: project.created_at.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          }
        end

        it 'returns project json' do
          freeze_time do
            patch :update, params: params

            expect(response).to be_ok
            expect(json_response).to eq(expected_response)
          end
        end
      end

      context 'when error occurred' do
        it 'returns errors' do
          patch :update, params: {
            organization_id: project.organization_id,
            id: project.id,
            name: ''
          }

          expect(response.status).to eq(422)
          expect(json_response).to eq(errors: ["Name can't be blank"])
        end
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }
      let!(:user) { create(:user, organization: organization) }

      it 'returns 404' do
        patch :update, params: {
          organization_id: organization.id,
          id: 1,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }
      let!(:user) { create(:user, organization: organization1) }

      it 'returns 404' do
        patch :update, params: {
          organization_id: organization1.id,
          id: project2.id,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when project exists' do
      let(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }

      it 'returns 200' do
        delete :destroy, params: { organization_id: project.organization_id, id: project.id }
        expect(response).to be_ok
      end
    end

    context 'when project does not exist' do
      let!(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }

      it 'returns 404' do
        delete :destroy, params: { organization_id: organization.id, id: 1 }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }
      let(:user) { create(:user, organization: organization1) }

      it 'returns 404' do
        delete :destroy, params: { organization_id: organization1.id, id: project2.id }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
