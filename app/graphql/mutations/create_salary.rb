module Mutations
  class CreateSalary < Mutations::BaseMutation
    include RoleAuthorization

    argument :employee_profile_id, ID, required: true
    argument :base_salary, Float, required: true
    argument :bonus, Float, required: false
    argument :deductions, Float, required: false
    argument :effective_from, GraphQL::Types::ISO8601Date, required: true

    field :salary, Types::SalaryType, null: true
    field :errors, [String], null: false

    def resolve(**args)
      current_user = context[:current_user]
      require_hr!(current_user)
      profile = EmployeeProfile.find_by(id: args[:employee_profile_id])
      raise GraphQL::ExecutionError, "Employee profile not found" unless profile

      salary = profile.salaries.new(
        base_salary: args[:base_salary],
        bonus: args[:bonus],
        deductions: args[:deductions],
        effective_from: args[:effective_from]
      )

      if salary.save
        {
          salary: salary,
          errors: []
        }
      else
        {
          salary: nil,
          errors: salary.errors.full_messages
        }
      end
    end
  end
end
