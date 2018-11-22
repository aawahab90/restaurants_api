module Api
  module V1
    class UsersController < ApplicationController

      skip_before_action :authorize_request, only: :create
      before_action :set_user, only: [:update_role]

      # POST /signup
      # return authenticated token upon signup
      def create
        user = User.new(user_params)
        if user.save
          @response = AuthenticateUser.new(user.email, user.password).call
        else
          json_response(Message.bad_request(user.errors.messages))
        end
      end

      def update_role
        authorize(User, :update_role?)
        if @user.update(role: params[:user][:role])
          json_response(Message.success("Role #{params[:user][:role]} Successfully updated"))
        else
          json_response(Message.bad_request(@user.errors.messages))
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name,
          :last_name,
          :phone,
          :address,
          :email,
          :password,
          :password_confirmation,
          :role
        )
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
