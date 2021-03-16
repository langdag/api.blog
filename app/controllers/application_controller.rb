class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from RailsParam::Param::InvalidParameterError, with: :render_error
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate

    private

    def action_create?
      action_name == 'create'
    end

    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token|
        current_user = User.find_by(token: token)
        if current_user
          @current_user = current_user
        else
          false
        end
      end
    end

    def render_error(error_message, status = :unprocessable_entity)
      message = error_message.is_a?(String) ? error_message : error_message.message.as_json
      render json: {error: message}, status: status
    end

    def render_unauthorized
      render_error('Bad credentials', :unauthorized)
    end

    def not_found
      render_error('Not found', :not_found)
    end
end
