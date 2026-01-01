module RoleAuthorization
  extend ActiveSupport::Concern

  def require_admin_or_hr!(user)
    unless user&.role.in?(%w[admin hr])
      raise GraphQL::ExecutionError, "Access denied: Only Admin or HR can perform this action"
    end
  end

  def require_hr!(user)
    unless user&.role == "hr"
      raise GraphQL::ExecutionError, "Access denied: Only HR can perform this action"
    end
  end
end
