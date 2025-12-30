module Mutations
  class Signup < Mutations::BaseMutation
    # =========================
    # 🔹 ARGUMENTS
    # =========================
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :firstname, String, required: true
    argument :lastname, String, required: true
    argument :resume, Types::Upload, required: false
    argument :bio, String, required: false
    argument :github_username, String, required: false
    argument :linkedin_url, String, required: false

    # =========================
    # 🔹 FIELDS
    # =========================
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    # =========================
    # 🔹 RESOLVER
    # =========================
    def resolve(**args)
      user = User.new(
        email: args[:email],
        password: args[:password],
        password_confirmation: args[:password_confirmation],
        firstname: args[:firstname],
        lastname: args[:lastname],
        bio: args[:bio],
        github_username: args[:github_username],
        linkedin_url: args[:linkedin_url]
      )

      user.resume.attach(args[:resume]) if args[:resume]

      if user.save
        token, _payload = Warden::JWTAuth::UserEncoder
          .new
          .call(user, :user, nil)

        {
          user: user,
          token: token,
          errors: []
        }
      else
        {
          user: nil,
          token: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
