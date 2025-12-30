class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_api_user!, only: :create

  def create
    user = User.new(sign_up_params)
    if user.save
      # 🔐 Dispatch JWT immediately after signup
      sign_in(:user, user)

      render json: {
        message: "Signed up successfully",
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :firstname,
      :lastname,
      :bio,
      :github_username,
    )
  end
end
