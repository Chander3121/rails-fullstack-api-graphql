module Types
  class LeaveType < Types::BaseObject
    field :id, ID, null: false
    field :employee, Types::EmployeeType, null: false
    field :leave_type, String, null: false
    field :start_date, GraphQL::Types::ISO8601Date, null: false
    field :end_date, GraphQL::Types::ISO8601Date, null: false
    field :status, String, null: true
    field :reason, String, null: false
    field :leave_days, Integer, null: false

    def leave_days
      (object.end_date - object.start_date).to_i + 1
    end

    def employee
      object.employee_profile.user
    end
  end
end
