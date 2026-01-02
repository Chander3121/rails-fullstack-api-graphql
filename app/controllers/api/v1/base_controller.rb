class Api::V1::BaseController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :force_json
  before_action :authenticate_api_user!

  private

  def force_json
    request.format = :json
  end

  def authenticate_api_user!
    # 🚨 HARD REQUIRE AUTH HEADER
    header = request.headers["Authorization"]
    return unauthorized!("Missing token") unless header&.start_with?("Bearer ")

    # 🚨 JWT ONLY — NO FALLBACK
    token = header.split(" ").last
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    return unauthorized!("You tried with expired token, sign in again to get a new token.") unless JwtDenylist.where(jti: payload["jti"]).empty?

    @current_user = User.find(payload["sub"])

    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        unauthorized!("Unauthorized")
  end

  def current_user
    @current_user
  end

  def unauthorized!(message)
    render json: { error: message }, status: :unauthorized
  end
end
