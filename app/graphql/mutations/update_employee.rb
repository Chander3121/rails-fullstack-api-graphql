module Mutations
  class UpdateEmployee < Mutations::BaseMutation
    include RoleAuthorization

    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :firstname, String, required: true
    argument :lastname, String, required: true
    argument :role, String, required: false, default_value: "employee"
    argument :resume, Types::Upload, required: false
    argument :bio, String, required: false
    argument :github_username, String, required: false
    argument :linkedin_url, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(**args)
      current_user = context[:current_user]
      require_admin_or_hr!(current_user)
      if args[:role] == "admin"
        return {
          user: nil,
          errors: [ "Cannot create user with admin role" ]
        }
      end
      user = User.new(
        email: args[:email],
        password: args[:password],
        password_confirmation: args[:password_confirmation],
        firstname: args[:firstname],
        lastname: args[:lastname],
        bio: args[:bio],
        role: args[:role],
        github_username: args[:github_username],
        linkedin_url: args[:linkedin_url]
      )

      if user.save
        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
