module Api
  module V1
    class ReservationsController < ApplicationController

      prepend_before_action :set_restaurant, except: [:index]
      before_action :set_reservation, only: [:show, :update, :destroy, :update_status]

      def index
        authorize(Reservation, :index?)
        @reservations = Reservation.search(params[:reservation_filters])
                                   .order('reservations.created_at desc')
                                   .paginate(:page => params[:page] || 1, :per_page => 15)
      end

      def create
        authorize(Reservation, :create?)
        @reservation = @restaurant.reservations.build(reservsation_params)

        unless @reservation.save
          json_response(Message.bad_request(@reservation.errors.messages))
        end
      end

      def show
        authorize(Reservation, :read?)
      end

      def update
        authorize(Reservation, :update?)
        unless @reservation.update(reservsation_params)
          json_response(Message.bad_request(@reservation.errors.messages))
        end
      end

      def update_status
        authorize(Reservation, :update?)
        if @reservation.update(status: params[:reservation][:status])
          json_response(Message.success("Reservation is successfully updated with status #{@reservation.status}"))
        else
          json_response(Message.bad_request(@reservation.errors.messages))
        end
      end

      def destroy
        authorize(Reservation, :destroy?)
        @reservation.destroy
        json_response(Message.successfully_deleted(@reservation.id, 'Reservation is successfully deleted'))
      end

      private

      def reservsation_params
        params.require(:reservation).permit(
          :status,
          :start_time,
          :covers,
          :note,
          :guest_id
        )
      end

      def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      end

      def set_reservation
        @reservation = @restaurant.reservations.find(params[:id])
      end
    end
  end
end