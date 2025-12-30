class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: :create

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      sign_in(:user, user) # dispatch JWT
      render json: { message: "Logged in successfully" }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    # 🚨 DO NOT manually create JwtDenylist
    # Devise-JWT middleware revokes automatically
    warden.logout(:user)

    render json: { message: "Logged out successfully" }
  end
end
