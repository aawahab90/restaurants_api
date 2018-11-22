class AuthenticationController < ApplicationController

  skip_before_action :authorize_request, only: :authenticate
  # return auth token once user is authenticated
  def authenticate
    user =
      AuthenticateUser.new(params[:authentication][:email],
                           params[:authentication][:password]).call
    response = { status: { code: 0, message: Message.successfully_login },
                           data: { accessToken: user[:accessToken], name: user[:name], id: user[:id] } }
    json_response(response)
  end

  private

  def auth_params
    params[:authentication].permit(:email, :password)
  end
end