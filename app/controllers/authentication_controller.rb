class AuthenticationController < ApplicationController
  # return auth token once user is authenticated
  def authenticate
    auth_token =
      AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token)
  end

  def destroy
    @curr = nil
    json_response(message: Message.logout)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def current
    @curr = AuthenticateUser.new(auth_params[:email],auth_params[:password]).curr_user
  end
end
