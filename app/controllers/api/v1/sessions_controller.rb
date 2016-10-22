module Api::V1
  class SessionsController < ApplicationController
    # skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      @user = User.find_for_database_authentication(email: params[:session][:email])
      return invalid_login_attempt unless @user

      if @user.valid_password?(params[:session][:password])
        sign_in :user, @user
        # render json: @user, serializer: SessionSerializer, root: nil
        render :text => @user.access_token, status: 200
      else
        invalid_login_attempt
      end
    end

    def verify_access_token
      user = User.find_by(access_token: params[:access_token])
      if user
        render text: "verified", status: 200
      else
        render text: "Token failed verification", status: 422
      end
    end

    private

    def invalid_login_attempt
      render text: "Email and password combination are invalid", status: 422
      # warden.custom_failure!
      # render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end



  end
end

# def create
#       user = User.find_by(email: params[:session][:email].downcase)
#         if user && user.authenticate(params[:session][:password])
#           render :text => user.access_token, status: 200
#         else
#           render text: "Email and password combination are invalid", status: 422
#         end
#     end
#     #Verifies the access_token so the client app would know if to login the user.
