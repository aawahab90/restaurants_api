require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers_without_auth) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    { user: attributes_for(:user, password_confirmation: user.password) }
  end


  # User signup test suite
  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/api/v1/users', params: valid_attributes.to_json, headers: headers_without_auth }

      it 'creates a new user' do
        expect(response).to have_http_status(200)
      end

      it 'returns with code 0' do
        expect(json['status']['code']).to eq(0)
      end

      it 'returns an authentication token' do
        expect(json['data']['accessToken']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/api/v1/users', params: { user: { password_confirmation: user.password } }.to_json, headers: headers_without_auth }

      it 'returns failure message' do
        expect(json['status']['message']['password']).to include("can't be blank")
        expect(json['status']['message']['first_name']).to include("can't be blank")
        expect(json['status']['message']['last_name']).to include("can't be blank")
        expect(json['status']['message']['email']).to include("can't be blank")
        expect(json['status']['message']['role']).to include("can't be blank")
      end
    end
  end

  #User Add Role
  describe 'POST /update_role' do
    before do 
      @user = create(:user)
      @restaurant_user = create(:user, role: 'restaurant_user')
      @admin_user = create(:user, role: 'admin')
      @valid_role = { user: { role: 'restaurant_user' }}
    end
    context 'when invalid request' do
      it 'returns with unauthorized error' do
        post "/api/v1/users/#{@user.id}/update_role", params: @valid_role.to_json,
             headers: valid_headers(@restaurant_user.id)
        expect(json['status']['error']).to eq('unauthorized')
      end

      it 'returns with error meesage and code 0 if inavlid role' do
        invalid_role = { user: { role: 'manager' }}
        post "/api/v1/users/#{@user.id}/update_role", params: invalid_role.to_json,
             headers: valid_headers(@admin_user.id)
        expect(json['status']['message']['role']).to include("is not included in the list")
      end
    end
    context 'when valid request' do
      it 'returns with success code 0' do
        post "/api/v1/users/#{@user.id}/update_role", params: @valid_role.to_json,
             headers: valid_headers(@admin_user.id)
        expect(json['status']['code']).to eq(0)
      end
    end
  end
end