class TaskSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :description, :project_id, :created_at, :updated_at
end
