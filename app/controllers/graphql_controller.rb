# frozen_string_literal: true

class GraphqlController < ActionController::API
  before_action :authenticate_graphql!

  def execute
    result = StrangeSchema.execute(
      params[:query],
      variables: prepare_variables(params[:variables]),
      context: {
        current_user: @current_user,
        request: request
      },
      operation_name: params[:operationName]
    )

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    render json: { errors: [{ message: e.message }], data: {} }, status: 500
  end

  private

  # =========================
  # 🔐 GRAPHQL AUTH
  # =========================
  def authenticate_graphql!
    return if public_graphql_operation?
    header = request.headers['Authorization']

    unless header&.start_with?('Bearer ')
      render_unauthorized("Missing token") and return
    end
    token = header.split(' ').last
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    return render_unauthorized("You tried with expired token, sign in again to get a new token.") if JwtDenylist.where(jti: payload['jti']).exists?
    @current_user = User.find(payload['sub'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render_unauthorized("Unauthorized")
  end

  # =========================
  # 🔓 PUBLIC OPS
  # =========================
  def public_graphql_operation?
    # Allow introspection
    return true if introspection_query?

    # Allow auth mutations by operationName
    %w[Login Signup].include?(params[:operationName])
  end

  def introspection_query?
    query_string = params[:query].to_s
    query_string.include?("__schema") || query_string.include?("__type")
  end

  # =========================
  # ❌ UNAUTHORIZED RESPONSE
  # =========================
  def render_unauthorized(message = "Unauthorized")
    render json: {
      errors: [{ message: message }],
      data: {}
    }, status: :unauthorized
  end

  # =========================
  # 🧩 HELPERS
  # =========================
  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end
end
