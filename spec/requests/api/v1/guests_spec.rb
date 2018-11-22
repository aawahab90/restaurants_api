require 'rails_helper'

RSpec.describe 'Guests API', type: :request do
  # initialize test data
  let(:admin_user) { create(:user, role: 'admin') }
  let(:restaurant_user) { create(:user, role: 'restaurant_user') }
  let(:guest_user) { create(:user) }
  let(:headers) { valid_headers(admin_user.id) }
  let(:restaurant) { create(:restaurant, created_by: admin_user) }
  let!(:guests) { create_list(:guest, 10, restaurant: restaurant) }
  let(:guest) { guests.first }
  let(:guest_id) { guest.id }

  # Test suite for GET /api/v1/restaurants/:restaurant_id/guests'
  describe 'GET /api/v1/restaurants/:restaurant_id/guests' do
    context 'with valid data' do
      # make HTTP get request before each example
      before { get "/api/v1/restaurants/#{restaurant.id}/guests", headers: headers }

      it 'returns guests' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json['data']['guests']).not_to be_empty
        expect(json['data']['guests'].size).to eq(10)
        expect(json['data']['pagination']['totalCount']).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid data' do
      it 'returns error restaurant not found' do
        get "/api/v1/restaurants/100/guests", headers: headers
        expect(json['message']).to include "Couldn't find Restaurant with 'id'=100"
      end

      it 'returns unauthorized error with guest user' do
        get "/api/v1/restaurants/#{restaurant.id}/guests", headers: valid_headers(guest_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error with restaurant user' do
        get "/api/v1/restaurants/#{restaurant.id}/guests", headers: valid_headers(restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for GET /api/v1/restaurants/:restaurant_id/guests/:id
  describe 'GET /api/v1/restaurants/:restaurant_id/guests/:id' do
    before { get "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the guest' do
        expect(json['data']).not_to be_empty
        expect(json['data']['firstName']).to eq(guest.first_name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:guest_id) { 500 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Guest with 'id'=500/)
      end
    end

    context 'with guest and restaurant_user user' do
      it 'returns unauthorized error' do
        get "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", headers: valid_headers(guest_user.id) 
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        get "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", headers: valid_headers(restaurant_user.id) 
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for POST /api/v1/restaurants/:restaurant_id/guests
  describe 'POST /api/v1/restaurants/:restaurant_id/guests' do
    # valid payload
    let(:valid_attributes) { { guest: { first_name: 'Learn', last_name: 'Elm',
                                        email: 'test@test.com', phone: '1114411' } }.to_json }
    let(:invalid_attributes) { { guest: { first_name: 'Learn'} }.to_json }

    context 'when the request is valid' do
      before { post "/api/v1/restaurants/#{restaurant.id}/guests", params: valid_attributes, headers: headers }

      it 'Creates a Guest' do
        expect(json['data']['firstName']).to eq('Learn')
        expect(json['data']['email']).to eq('test@test.com')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is not present' do
      before { post "/api/v1/restaurants/#{restaurant.id}/guests", params: valid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to eq("{\"message\":\"Missing token\"}")
      end
    end

    context 'when the request is invalid' do
      before { post "/api/v1/restaurants/#{restaurant.id}/guests", params: invalid_attributes, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a validation failure message' do
        expect(json['status']['message']['last_name']).to include "can't be blank"
        expect(json['status']['message']['email']).to include "can't be blank"
        expect(json['status']['message']['phone']).to include "can't be blank"
      end
    end

    context 'with guest and restaurant_user user' do
      it 'returns unauthorized error' do
        post "/api/v1/restaurants/#{restaurant.id}/guests", params: valid_attributes,
              headers: valid_headers(guest_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        post "/api/v1/restaurants/#{restaurant.id}/guests", params: valid_attributes,
              headers: valid_headers(restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for PUT /api/v1/restaurants/:restaurant_id/guests/:id
  describe 'PUT /api/v1/restaurants/:restaurant_id/guests/:id' do
    let(:valid_attributes) { { guest: { first_name: 'Andrew' } }.to_json }

    context 'when the record exists' do
      before { 
        put "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", params: valid_attributes, headers: headers
      }

      it 'updates the record' do
        expect(json['data']['firstName']).to eq('Andrew')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      before { put "/api/v1/restaurants/#{restaurant.id}/guests/100", params: valid_attributes, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user is not exist' do
      before { put "/api/v1/restaurants/100", params: valid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'with guest and restaurant user' do
      it 'returns unauthorized error' do
        put "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", params: valid_attributes,
            headers: valid_headers(guest_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        put "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", params: valid_attributes,
            headers: valid_headers(restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for DELETE /api/v1/restaurants/:restaurant_id/guests/:id
  describe 'DELETE /api/v1/restaurants/:restaurant_id/guests/:id' do

    it 'returns status code 422' do
      delete "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}"
      expect(response).to have_http_status(422)
    end

    it 'returns status code 200' do
      delete "/api/v1/restaurants/#{restaurant.id}/guests/#{guest_id}", headers: headers 
      expect(response).to have_http_status(200)
    end
  end
end