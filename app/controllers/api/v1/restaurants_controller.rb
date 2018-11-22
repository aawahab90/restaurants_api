module Api
  module V1
    class RestaurantsController < ApplicationController

      before_action :set_restaurant, only: [:update, :destroy, :show]

      def index
        authorize(Restaurant, :read?)
        @restaurants = Restaurant.search(params[:resturant_filters])
                       .order('created_at desc')
                       .paginate(:page => params[:page] || 1, :per_page => 15)
      end

      def create
        authorize(Restaurant, :create?)
        @restaurant = Restaurant.new(restaurant_params)
        @restaurant.created_by = current_user
        unless @restaurant.save
          json_response(Message.bad_request(@restaurant.errors.messages))
        end
      end

      def show
        authorize(Restaurant, :read?)
      end

      def update
        authorize(Restaurant, :update?)
        unless @restaurant.update(restaurant_params)
          json_response(Message.bad_request(@restaurant.errors.messages))
        end
      end

      def destroy
        authorize(Restaurant, :destroy?)
        @restaurant.update(archive: true)
        json_response(Message.successfully_deleted(@restaurant.id, "#{@restaurant.name} restaurant is successfully deleted}"))
      end

      private

      def restaurant_params
        params.require(:restaurant).permit(
          :name,
          :phone,
          :email,
          :location,
          :opening_hour,
          :closing_hour,
          :created_by_id
        )
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:id])
      end
    end
  end
end