# frozen_string_literal: true

module Mutations
  class Logout < BaseMutation
    null false

    field :success, Boolean, null: false
    field :message, String, null: false

    def resolve
      # 1️⃣ Get raw JWT
      auth_header = context[:request].headers["Authorization"]
      raise "Missing token" unless auth_header&.start_with?("Bearer ")

      token = auth_header.split(" ").last

      # 2️⃣ Decode JWT
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)

      # 3️⃣ Revoke via denylist strategy (CORRECT way)
      JwtDenylist.revoke_jwt(payload, context[:current_user])

      {
        success: true,
        message: "Logged out successfully"
      }
    rescue StandardError => e
      {
        success: false,
        message: e.message
      }
    end
  end
end
