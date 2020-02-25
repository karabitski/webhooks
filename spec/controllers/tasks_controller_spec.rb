require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    let!(:project1) { create(:project) }
    let!(:project2) { create(:project) }
    let!(:task1) { create(:task, project: project1) }
    let!(:task2) { create(:task, project: project2) }

    it 'returns all tasks for project' do
      get :index, params: {project_id: project1.id}

      expect(response).to be_ok
      expect(json_response).to eq(
        data: [{
          id: task1.id.to_s,
          type: 'task',
          attributes: {
            name: task1.name,
            description: task1.description,
            project_id: project1.id,
            created_at: task1.created_at.as_json,
            updated_at: task1.updated_at.as_json
          }
        }]
      )
    end
  end

  describe 'POST #create' do
    let(:project) { create(:project) }

    context 'successfully created' do
      it 'returns task json' do
        freeze_time do
          post :create,
               params: {project_id: project.id, name: 'Test Name', description: 'Test Desc'}

          expect(response).to be_ok
          expect(json_response).to eq(
            data: {
              id: '1',
              type: 'task',
              attributes: {
                name: 'Test Name',
                description: 'Test Desc',
                project_id: project.id,
                created_at: Time.zone.now.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          )
        end
      end
    end

    context 'error occurred' do
      it 'returns errors' do
        post :create, params: {project_id: project.id}

        expect(response.status).to eq(422)
        expect(json_response).to eq(
          errors: ["Name can't be blank", "Description can't be blank"]
        )
      end
    end
  end

  describe 'GET #show' do
    context 'task exists' do
      let(:task) { create(:task) }

      it 'returns task json' do
        get :show, params: {project_id: task.project_id, id: task.id}

        expect(response).to be_ok
        expect(json_response).to eq(
          data: {
            id: task.id.to_s,
            type: 'task',
            attributes: {
              name: task.name,
              description: task.description,
              project_id: task.project_id,
              created_at: task.created_at.as_json,
              updated_at: task.updated_at.as_json
            }
          }
        )
      end
    end

    context 'task does not exist' do
      let!(:project) { create(:project) }

      it 'returns 404' do
        get :show, params: {project_id: project.id, id: 1}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }

      it 'returns 404' do
        get :show, params: {project_id: project1.id, id: project2.id}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'task exists' do
      let(:task) { create(:task) }

      context 'successfully updated' do
        it 'returns task json' do
          freeze_time do
            patch :update, params: {
              project_id: task.project_id,
              id: task.id,
              name: 'Random Test Name'
            }
  
            expect(response).to be_ok
            expect(json_response).to eq(
              data: {
                id: task.id.to_s,
                type: 'task',
                attributes: {
                  name: 'Random Test Name',
                  description: task.description,
                  project_id: task.project_id,
                  created_at: task.created_at.as_json,
                  updated_at: Time.zone.now.as_json
                }
              }
            )
          end
        end
      end

      context 'error occurred' do
        it 'returns errors' do
          patch :update, params: {
            project_id: task.project_id,
            id: task.id,
            name: ''
          }

          expect(response.status).to eq(422)
          expect(json_response).to eq(
            errors: ["Name can't be blank"]
          )
        end
      end
    end

    context 'task does not exist' do
      let!(:project) { create(:project) }

      it 'returns 404' do
        patch :update, params: {
          project_id: project.id,
          id: 1,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'task does not exist for organization' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }

      it 'returns 404' do
        patch :update, params: {
          project_id: project1.id,
          id: task2.id,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'task exists' do
      let(:task) { create(:task) }

      it 'returns 200' do
        delete :destroy, params: {project_id: task.project_id, id: task.id}
        expect(response).to be_ok
      end
    end

    context 'task does not exist' do
      let!(:project) { create(:project) }

      it 'returns 404' do
        delete :destroy, params: {project_id: project.id, id: 1}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'task does not exist for project' do
      let!(:project1) { create(:project) }
      let!(:project2) { create(:project) }
      let!(:task1) { create(:task, project: project1) }
      let!(:task2) { create(:task, project: project2) }

      it 'returns 404' do
        delete :destroy, params: {project_id: project1.id, id: task2.id}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
