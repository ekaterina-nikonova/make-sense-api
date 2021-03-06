# frozen_string_literal: true

# See https://blog.usejournal.com/rails-api-jwt-auth-vuejs-spa-eb4cf740a3ae
# pt. 13
module Api::V1
  class SignupController < ApplicationController
    def create
      if check_invitation(params[:invitation_code])
        create_user
      else
        render json: { error: 'No invitation found' },
               status: :forbidden
      end
    end

    def create_guest
      timestamp = DateTime.now.strftime('%Q')
      user = User.new(role: :guest,
                      username: "guest-#{timestamp}",
                      email: "guest-#{timestamp}@example.com",
                      password: "guest-#{timestamp}",
                      password_confirmation: "guest-#{timestamp}")

      return unless user.save

      create_session_for user
    end

    private

    def check_invitation(code)
      invitation = Invitation.find_by(email: user_params[:email])
      invitation && (invitation.code.eql? code)
    end

    def user_params
      params.require(:invitation_code)
      params.permit(:email, :username, :password, :password_confirmation)
    end

    def create_user
      user = User.new(user_params.merge! role: :user)

      if user.save
        use_invitation user.email
        create_session_for user
      else
        render json: { error: user.errors.full_messages.join(' ') },
               status: :unprocessable_entity
      end
    end

    def create_session_for(user)
      payload = { user_id: user.id, aud: [user.role] }
      session = JWTSessions::Session.new(payload: payload,
                                         refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    end

    def use_invitation(email)
      invitation = Invitation.find_by(email: email)
      invitation.use
    end
  end
end
