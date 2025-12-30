class Api::V1::ProfilesController < Api::V1::BaseController
  def show
    render json: {
      id: current_user.id,
      email: current_user.email,
      message: "JWT is working 🎉"
    }
  end
end
