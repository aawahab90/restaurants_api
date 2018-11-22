require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  # initialize test data
  let(:admin_user) { create(:user, role: 'admin') }
  let(:restaurant_user) { create(:user, role: 'restaurant_user') }
  let(:guest_user) { create(:user) }
  let(:headers) { valid_headers(admin_user.id) }
  let(:restaurant) { create(:restaurant, created_by: admin_user) }
  let(:guest) { create(:guest, restaurant: restaurant) }
  let!(:reservations) { create_list(:reservation, 10, guest: guest, restaurant: restaurant) }
  let(:reservation) { reservations.first }
  let(:reservation_id) { reservation.id }

  # Test suite for GET /api/v1/reservations
  describe 'GET /api/v1/reservations' do
    context 'without filters' do
      # make HTTP get request before each example
      before { get '/api/v1/reservations', headers: headers }

      it 'returns reservations' do
        expect(json['data']['reservations']).not_to be_empty
        expect(json['data']['reservations'].size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with filters' do
      it 'returns reservations guest emails' do
        get '/api/v1/reservations', params: { reservation_filters: { emails: [guest.email] } }, headers: headers
        expect(json['data']['reservations']).not_to be_empty
      end

      it 'returns reservations with restaurant id' do
        get '/api/v1/reservations', params: { reservation_filters: { restaurant_ids: [restaurant.id] } }, headers: headers
        expect(json['data']['reservations']).not_to be_empty
      end

      it 'will not returns reservations' do
        get '/api/v1/reservations', params: { reservation_filters: { restaurant_ids: [500] } }, headers: headers
        expect(json['data']['reservations']).to be_empty
      end
    end

    context 'with restaurant_user user' do
      let(:headers) { valid_headers(restaurant_user.id) }
      it 'returns reservations' do
        get '/api/v1/reservations', params: { reservation_filters: { emails: [guest.email] } }, headers: headers
        expect(json['data']['reservations']).not_to be_empty
      end
    end

    context 'with guest user' do
      let(:headers) { valid_headers(guest_user.id) }
      it 'returns reservations' do
        get '/api/v1/reservations', params: { reservation_filters: { emails: [guest.email] } }, headers: headers
        expect(json['data']['reservations']).not_to be_empty
      end
    end
  end

  # Test suite for GET /api/v1/restaurants/:restaurant_id/reservations/:id
  describe 'GET /api/v1/restaurants/:restaurant_id/reservations/:id' do
    before { get "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the reservation' do
        expect(json['data']).not_to be_empty
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:reservation_id) { 500 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Reservation with 'id'=500/)
      end
    end

    context 'with guest_user and restaurant_user' do
      it 'returns the reservation' do
        get "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation.id}",
        headers: valid_headers(guest_user.id)
        expect(json['data']).not_to be_empty
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
      end

      it 'returns the reservation' do
        get "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation.id}",
        headers: valid_headers(restaurant_user.id)
        expect(json['data']).not_to be_empty
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
      end
    end
  end

  # Test suite for POST /api/v1/restaurants/:restaurant_id/reservations
  describe 'POST /api/v1/restaurants/:restaurant_id/reservations' do
    # valid payload
    let(:valid_attributes) { { reservation: { status: 'pending', start_time: Time.now.to_s,
                                        covers: 4, note: 'Learn Elm', guest_id: guest.id } }.to_json }
    let(:invalid_attributes) { { reservation: { status: 'pending'} }.to_json }

    context 'when the request is valid' do
      before { post "/api/v1/restaurants/#{restaurant.id}/reservations", params: valid_attributes, headers: headers }

      it 'Creates a reservation' do
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
        expect(json['data']['status']).to eq('pending')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is not present' do
      before { post "/api/v1/restaurants/#{restaurant.id}/reservations", params: valid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to eq("{\"message\":\"Missing token\"}")
      end
    end

    context 'when the request is invalid' do
      before { post "/api/v1/restaurants/#{restaurant.id}/reservations", params: invalid_attributes, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a validation failure message' do
        expect(json['status']['message']['start_time']).to include "can't be blank"
        expect(json['status']['message']['covers']).to include "can't be blank"
        expect(json['status']['message']['guest_id']).to include "can't be blank"
      end
    end

    context 'with guest and restaurant_user user' do
      it 'Creates a reservation' do
        post "/api/v1/restaurants/#{restaurant.id}/reservations", params: valid_attributes,
              headers: valid_headers(guest_user.id)
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
        expect(json['data']['status']).to eq('pending')
      end

      it 'Creates a reservation' do
        post "/api/v1/restaurants/#{restaurant.id}/reservations", params: valid_attributes,
              headers: valid_headers(restaurant_user.id)
        expect(json['data']['guest']['firstName']).to eq(guest.first_name)
        expect(json['data']['status']).to eq('pending')
      end
    end
  end

  # Test suite for PUT /api/v1/restaurants/:id
  describe 'PUT /api/v1/restaurants/:restaurant_id/reservations/:id' do
    let(:valid_attributes) { { reservation: { status: 'approved', covers: 5 } }.to_json }

    context 'when the record exists' do
      before { 
        put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", params: valid_attributes, headers: headers
      }

      it 'updates the record' do
        expect(json['data']['status']).to eq('approved')
        expect(json['data']['covers']).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      before { put "/api/v1/restaurants/#{restaurant.id}/reservations/100", params: valid_attributes, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user is not exist' do
      before { put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", params: valid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'with guest and restaurant user' do
      it 'returns unauthorized error' do
        put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", params: valid_attributes,
            headers: valid_headers(guest_user.id)
        expect(json['data']['status']).to eq('approved')
        expect(json['data']['covers']).to eq(5)
      end

      it 'returns unauthorized error' do
        put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", params: valid_attributes,
            headers: valid_headers(restaurant_user.id)
        expect(json['data']['status']).to eq('approved')
        expect(json['data']['covers']).to eq(5)
      end
    end
  end

  # Test suite for PUT /api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}/update_status
  describe 'PUT /api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}/update_status' do
    context 'when the record exist for updating the status'
      it 'update the status' do
        valid_status = { reservation: { status: 'approved' }}
        put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}/update_status",
            params: valid_status.to_json, headers: headers
        expect(json['status']['message']).to eq('Reservation is successfully updated with status approved')
      end

      it 'returns with error meesage and code 0 if inavlid role' do
        invalid_status = { reservation: { status: 'test' }}
        put "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}/update_status",
             params: invalid_status.to_json, headers: headers
        expect(json['status']['message']['status']).to include("is not included in the list")
      end
  end

  # Test suite for DELETE /api/v1/restaurants/:restaurant_id/reservations/:id
  describe 'DELETE /api/v1/restaurants/:restaurant_id/reservations/:id' do

    it 'returns status code 422' do
      delete "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}"
      expect(response).to have_http_status(422)
    end

    it 'returns status code 200' do
      delete "/api/v1/restaurants/#{restaurant.id}/reservations/#{reservation_id}", headers: headers 
      expect(response).to have_http_status(200)
    end
  end
end