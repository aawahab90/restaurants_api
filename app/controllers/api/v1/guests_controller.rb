module Api
  module V1
    class GuestsController < ApplicationController

      prepend_before_action :set_restaurant
      before_action :set_guest, only: [:show, :update, :destroy]

      def index
        authorize(Guest, :read?)
        @guests = @restaurant.guests
                             .order('guests.created_at desc')
                             .paginate(:page => params[:page] || 1, :per_page => 15)
      end

      def create
        authorize(Guest, :create?)
        @guest = @restaurant.guests.build(guests_params)
        unless @guest.save
          json_response(Message.bad_request(@guest.errors.messages))
        end
      end

      def show
        authorize(Guest, :read?)
      end

      def update
        authorize(Guest, :update?)
        unless @guest.update(guests_params)
          json_response(Message.bad_request(@guest.errors.messages))
        end
      end

      def destroy
        authorize(Guest, :destroy?)
        @guest.destroy
        json_response(Message.successfully_deleted(@guest.id, "Guest #{@guest.name} is successfully deleted}"))
      end

      private

      def guests_params
        params.require(:guest).permit(
          :first_name,
          :last_name,
          :email,
          :phone
        )
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      end

      def set_guest
        @guest = @restaurant.guests.find(params[:id])
      end
    end
  end
end