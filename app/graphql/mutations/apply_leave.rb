module Mutations
  class ApplyLeave < Mutations::BaseMutation
    argument :start_date, GraphQL::Types::ISO8601Date, required: true
    argument :end_date, GraphQL::Types::ISO8601Date, required: true
    argument :leave_type, String, required: true
    argument :reason, String, required: false

    field :leave, Types::LeaveType, null: true
    field :errors, [String], null: false

    def resolve(start_date:, end_date:, leave_type:, reason: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      profile = user.employee_profile
      raise GraphQL::ExecutionError, "Employee profile not found" unless profile

      if end_date <= start_date
        return {
          leave: nil,
          errors: ["End date must be greater than start date"]
        }
      end

      leave = profile.leaves.new(
        start_date: start_date,
        end_date: end_date,
        leave_type: leave_type,
        status: "pending",
        reason: reason
      )

      if leave.save
        {
          leave: leave,
          errors: []
        }
      else
        {
          leave: nil,
          errors: leave.errors.full_messages
        }
      end
    end
  end
end
