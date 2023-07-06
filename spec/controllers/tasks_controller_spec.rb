# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before do
    allow(controller).to receive(:find_user_by_token).and_return(user)
  end

  describe 'GET #index' do
    let!(:project1) { create(:project) }
    let!(:user) { create(:user, organization: project1.organization) }
    let!(:task1) { create(:task, project: project1, owner: user, assignee: user) }
    let(:expected_response) do
      {
        data: [{
          id: task1.id.to_s,
          type: 'task',
          attributes: {
            owner_id: user.id,
            assignee_id: user.id,
            name: task1.name,
            description: task1.description,
            project_id: project1.id,
            created_at: task1.created_at.as_json,
            updated_at: task1.updated_at.as_json
          }
        }]
      }
    end

    it 'returns all tasks for project' do
      get :index, params: { project_id: project1.id }

      expect(response).to be_ok
      expect(json_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    let(:project) { create(:project) }
    let(:user) { create(:user, organization: project.organization) }
    let(:task) { Task.order(id: :desc).first }

    context 'when successfully created' do
      let(:params) do
        { project_id: project.id, name: 'Test Name', description: 'Test Desc', owner_id: user.id, assignee_id: user.id }
      end
      let(:expected_response) do
        {
          data: {
            id: task.id.to_s,
            type: 'task',
            attributes: {
              owner_id: user.id,
              assignee_id: user.id,
              name: 'Test Name',
              description: 'Test Desc',
              project_id: project.id,
              created_at: Time.zone.now.as_json,
              updated_at: Time.zone.now.as_json
            }
          }
        }
      end

      it 'returns task json' do
        freeze_time do
          post :create, params: params

          expect(response).to be_ok
          expect(json_response).to eq(expected_response)
        end
      end
    end

    context 'when error occurred' do
      it 'returns errors' do
        post :create, params: { project_id: project.id }

        expect(response.status).to eq(422)
        expect(json_response).to eq(
          errors: ['Assignee must exist', 'Owner must exist', "Name can't be blank", "Description can't be blank"]
        )
      end
    end
  end

  describe 'GET #show' do
    context 'when task exists' do
      let(:project) { create(:project) }
      let(:task) { create(:task, project: project, owner: user, assignee: user) }
      let(:user) { create(:user, organization: project.organization) }
      let(:expected_response) do
        {
          data: {
            id: task.id.to_s,
            type: 'task',
            attributes: {
              owner_id: user.id,
              assignee_id: user.id,
              name: task.name,
              description: task.description,
              project_id: task.project_id,
              created_at: task.created_at.as_json,
              updated_at: task.updated_at.as_json
            }
          }
        }
      end

      it 'when returns task json' do
        get :show, params: { project_id: task.project_id, id: task.id }

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }

      it 'returns 404' do
        get :show, params: { project_id: project.id, id: 1 }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }
      let(:user) { create(:user, organization: project1.organization) }

      it 'returns 404' do
        get :show, params: { project_id: project1.id, id: project2.id }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when task exists' do
      let(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }
      let(:task) { create(:task, project: project, owner: user, assignee: user) }

      context 'when successfully updated' do
        let(:params) do
          {
            project_id: task.project_id,
            id: task.id,
            name: 'Random Test Name'
          }
        end
        let(:expected_response) do
          {
            data: {
              id: task.id.to_s,
              type: 'task',
              attributes: {
                owner_id: user.id,
                assignee_id: user.id,
                name: 'Random Test Name',
                description: task.description,
                project_id: task.project_id,
                created_at: task.created_at.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          }
        end

        it 'returns task json' do
          freeze_time do
            patch :update, params: params

            expect(response).to be_ok
            expect(json_response).to eq(expected_response)
          end
        end
      end

      context 'when error occurred' do
        let(:params) do
          {
            project_id: task.project_id,
            id: task.id,
            name: ''
          }
        end

        it 'returns errors' do
          patch :update, params: params

          expect(response.status).to eq(422)
          expect(json_response).to eq(errors: ["Name can't be blank"])
        end
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }
      let(:params) do
        {
          project_id: project.id,
          id: 1,
          name: 'Test'
        }
      end

      it 'returns 404' do
        patch :update, params: params

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for organization' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task2) { create(:task, project: project2) }
      let(:user) { create(:user, organization: project1.organization) }
      let(:params) do
        {
          project_id: project1.id,
          id: task2.id,
          name: 'Test'
        }
      end

      it 'returns 404' do
        patch :update, params: params

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when task exists' do
      let(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }
      let(:task) { create(:task) }

      it 'returns 200' do
        delete :destroy, params: { project_id: task.project_id, id: task.id }
        expect(response).to be_ok
      end
    end

    context 'when task does not exist' do
      let!(:project) { create(:project) }
      let(:user) { create(:user, organization: project.organization) }

      it 'returns 404' do
        delete :destroy, params: { project_id: project.id, id: 1 }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'when task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }
      let(:user) { create(:user, organization: project1.organization) }

      it 'returns 404' do
        delete :destroy, params: { project_id: project1.id, id: task2.id }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
