module Types
  class EmployeeProfile < Types::BaseObject
    field :id, ID, null: false
    field :department, String, null: true
    field :employee_id, String, null: false
    field :employment_type, String, null: true
    field :exit_date, String, null: true
    field :joining_date, String, null: false
    field :status, String, null: false
  end
end
