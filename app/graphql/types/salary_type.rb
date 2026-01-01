module Types
  class SalaryType < Types::BaseObject
    field :id, ID, null: false
    field :employee, Types::EmployeeType, null: false
    field :base_salary, Float, null: false
    field :bonus, Float, null: true
    field :deductions, Float, null: true
    field :effective_from, GraphQL::Types::ISO8601Date, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    def employee
      object.employee_profile.user
    end
  end
end
