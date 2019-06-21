# frozen_string_literal: true

# See https://blog.usejournal.com/rails-api-jwt-auth-vuejs-spa-eb4cf740a3ae
# pt. 13
module Api::V1
  class SignupController < ApplicationController
    def create
      user = User.new(user_params)
  
      if user.save
        payload = { user_id: user.id }
        session = JWTSessions::Session.new(payload: payload,
                                           refresh_by_access_allowed: true)
        tokens = session.login
  
        response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            # secure: Rails.env.production?,
                            secure: false)
        render json: { csrf: tokens[:csrf] }
      else
        render json: { error: user.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.permit(:email, :username, :password, :password_confirmation)
    end
  end
end
