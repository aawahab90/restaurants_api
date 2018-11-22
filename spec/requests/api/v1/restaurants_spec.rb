require 'rails_helper'

RSpec.describe 'Restaurants API', type: :request do
  # initialize test data
  let(:admin_user) { create(:user, role: 'admin') }
  let(:restaurant_user) { create(:user, role: 'restaurant_user') }
  let(:guest_user) { create(:user) }
  let(:headers) { valid_headers(admin_user.id) }
  let!(:restaurants) { create_list(:restaurant, 10, created_by: admin_user) }
  let(:restaurant) { restaurants.first }
  let(:restaurant_id) { restaurant.id }

  # Test suite for GET /api/v1/restaurants
  describe 'GET /api/v1/restaurants' do
    context 'with out :search' do
      # make HTTP get request before each example
      before { get '/api/v1/restaurants', headers: headers }

      it 'returns restaurants' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json['data']['restaurants']).not_to be_empty
        expect(json['data']['restaurants'].size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with :query' do
      it 'returns restaurants with name' do
        get '/api/v1/restaurants', params: { resturant_filters: { query: restaurant.name } }, headers: headers
        expect(json['data']['restaurants']).not_to be_empty
      end

      it 'returns restaurants with description' do
        get '/api/v1/restaurants', params: { resturant_filters: { query: restaurant.location[0..15] } }, headers: headers
        expect(json['data']['restaurants']).not_to be_empty
      end

      it 'will not returns restaurants' do
        get '/api/v1/restaurants', params: { resturant_filters: { query: 'copper kattel' } }, headers: headers
        expect(json['data']['restaurants']).to be_empty
      end
    end


    context 'with guest user' do
      let(:headers) { valid_headers(guest_user.id) }
      it 'returns unauthorized error' do
        get '/api/v1/restaurants', params: { resturant_filters: { query: restaurant.name } }, headers: headers
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for GET /api/v1/restaurants/:id
  describe 'GET /api/v1/restaurants/:id' do
    before { get "/api/v1/restaurants/#{restaurant_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the restaurant' do
        expect(json['data']).not_to be_empty
        expect(json['data']['name']).to eq(restaurant.name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:restaurant_id) { 500 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Restaurant with 'id'=500/)
      end
    end

    context 'with guest and restaurant_user user' do
      it 'returns unauthorized error' do
        get "/api/v1/restaurants/#{restaurant_id}", headers: valid_headers(guest_user.id) 
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        get "/api/v1/restaurants/#{restaurant_id}", headers: valid_headers(restaurant_user.id) 
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for POST /api/v1/restaurants
  describe 'POST /api/v1/restaurants' do
    # valid payload
    let(:valid_attributes) { { restaurant: { name: 'Learn Elm', location: 'Testing',
                                        email: 'test@test.com', phone: '1114411' } }.to_json }
    let(:invalid_attributes) { { restaurant: { name: 'Learn Elm'} }.to_json }

    context 'when the request is valid' do
      before { post '/api/v1/restaurants', params: valid_attributes, headers: headers }

      it 'creates a Restaurant' do
        expect(json['data']['name']).to eq('Learn Elm')
        expect(json['data']['createdBy']).to eq(admin_user.name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user is not present' do
      before { post '/api/v1/restaurants', params: valid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to eq("{\"message\":\"Missing token\"}")
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/restaurants', params: invalid_attributes, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a validation failure message' do
        expect(json['status']['message']['location']).to include "can't be blank"
        expect(json['status']['message']['email']).to include "can't be blank"
      end
    end

    context 'with guest and restaurant_user user' do
      it 'returns unauthorized error' do
        post '/api/v1/restaurants', params: valid_attributes,
              headers: valid_headers(guest_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        post '/api/v1/restaurants', params: valid_attributes,
              headers: valid_headers(restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for PUT /api/v1/restaurants/:id
  describe 'PUT /api/v1/restaurants/:id' do
    let(:valid_attributes) { { restaurant: { name: 'copper kattel' } }.to_json }

    context 'when the record exists' do
      before { 
        put "/api/v1/restaurants/#{restaurant_id}", params: valid_attributes, headers: headers
      }

      it 'updates the record' do
        expect(json['data']['name']).to eq('copper kattel')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      before { put "/api/v1/restaurants/100", params: valid_attributes, headers: headers }

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
        put "/api/v1/restaurants/#{restaurant_id}", params: valid_attributes,
            headers: valid_headers(guest_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns unauthorized error' do
        put "/api/v1/restaurants/#{restaurant_id}", params: valid_attributes,
            headers: valid_headers(restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end
    end
  end

  # Test suite for DELETE /api/v1/restaurants/:id
  describe 'DELETE /api/v1/restaurants/:id' do

    it 'returns status code 422' do
      delete "/api/v1/restaurants/#{restaurant_id}"
      expect(response).to have_http_status(422)
    end

    it 'returns status code 200' do
      delete "/api/v1/restaurants/#{restaurant_id}", headers: headers 
      expect(response).to have_http_status(200)
    end
  end
end