# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include RoleAuthorization

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end
    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end
    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :me, Types::UserType, null: true, description: "Returns the currently authenticated user"
    def me
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      user
    end

    field :get_user, Types::UserType, null: true, description: "Fetches the user by ID." do
      argument :id, ID, required: true
    end
    def get_user(id:)
      User.find_by(id: id)
    end

    field :get_employees, [Types::EmployeeType], null: false, description: "Fetches all employees"
    def get_employees
      current_user = context[:current_user]
      require_admin_or_hr!(current_user)
      if current_user.role == 'admin'
        User.where.not(role: 'admin')
      else
        User.where(role: 'employee')
      end
    end

    field :my_leaves, [Types::LeaveType], null: false, description: "Fetches all leaves for the current user"
    def my_leaves
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      user.employee_profile.leaves
    end

    field :user_leaves, [Types::LeaveType], null: false, description: "Fetches all leaves for the current user" do
      argument :user_id, ID, required: true
    end
    def user_leaves(user_id:)
      current_user = context[:current_user]
      require_admin_or_hr!(current_user)
      User.find_by(id: user_id).employee_profile.leaves
    end

    field :leave_approve, Types::LeaveType, null: false, description: "Approve a leave request" do
      argument :leave_id, ID, required: true
    end
    def leave_approve(leave_id:)
      current_user = context[:current_user]
      require_hr!(current_user)
      leave = Leave.find_by(id: leave_id)
      raise GraphQL::ExecutionError, "Leave not found" unless leave

      leave.status = "approved"
      leave.leave_type = "casual" if leave.leave_type.blank?
      if leave.save
        leave
      else
        raise GraphQL::ExecutionError, leave.errors.full_messages.join(", ")
      end
    end
  end
end
