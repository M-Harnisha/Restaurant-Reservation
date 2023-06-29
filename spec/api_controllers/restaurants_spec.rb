require 'rails_helper'

RSpec.describe Api::RestaurantsController , type: :request do
  
  let(:user) {create(:user)}
  let(:user_account) {create(:account,:for_user,accountable:user)}

  let(:owner) {create(:owner)}
  let(:owner_account) {create(:account,:for_owner,accountable:owner)}

  let(:owner1) {create(:owner)}
  let(:owner1_account) {create(:account,:for_owner,accountable:owner1)}

  let!(:restaurant) {create(:restaurant,owner:owner)}
  
  let(:user_token) {create(:doorkeeper_access_token,resource_owner_id:user_account.id)}
  let(:owner_token) {create(:doorkeeper_access_token,resource_owner_id:owner_account.id)}
  let(:owner_token1) {create(:doorkeeper_access_token,resource_owner_id:owner1_account.id)}

  describe "get index" do

    context "when there is no access token" do
      before do
        get "/api",params:{access_token:user_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is user" do
      before do
        get "/api",params:{access_token:user_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is user with no restaurants" do
      before do
        restaurant.destroy
        get "/api",params:{access_token:user_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end

    context "when the user is owner" do
      before do
        get "/api",params:{access_token:owner_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is owner with no restaurant" do
      before do
        restaurant.destroy
        get "/api",params:{access_token:owner_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end

  end

  describe "get show" do

    context "when there is no access token" do
      before do
        get "/api/restaurants/#{restaurant.id}",params:{access_token:user_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is user" do
      before do
        get "/api/restaurants/#{restaurant.id}",params:{access_token:user_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is user with no restaurant" do
      before do
        restaurant.destroy
        get "/api/restaurants/#{restaurant.id}",params:{access_token:user_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end

    context "when the user is owner" do
      before do
        get "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is owner with no restaurant" do
      before do
        restaurant.destroy
        get "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end

  end


  describe "post create" do

    context "when there is no access token" do
      before do
        post "/api/restaurants"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end

    context "when the user is user" do
      before do
        post "/api/restaurants",params:{access_token:user_token.token}
      end
      it "should have http status 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the user is owner" do
      before do
        post "/api/restaurants",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:restaurant.contact,owner:owner}}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the user is owner with wrong params" do
      before do
        post "/api/restaurants",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"0987",owner:owner}}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end

  end

  describe "patch update" do

    context "when there is no access token" do
      before do
        patch "/api/restaurants/#{restaurant.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end

    context "when the user is user" do
      before do
        patch "/api/restaurants/#{restaurant.id}",params:{access_token:user_token.token}
      end
      it "should have http status 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the user is owner1" do
      before do
        patch "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token1.token}
      end
      it "should have http status 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the user is owner" do
      before do
        patch "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"9842040552",owner:owner}}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is owner with wrong params" do
      before do
        patch "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"0987",owner:owner}}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end

    context "when the user is owner with no restaurant found" do
      before do
        patch "/api/restaurants/100",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"0987",owner:owner}}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "delete destroy" do

    context "when there is no access token" do
      before do
        delete "/api/restaurants/#{restaurant.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end

    context "when the user is user" do
      before do
        delete "/api/restaurants/#{restaurant.id}",params:{access_token:user_token.token}
      end
      it "should have http status 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the user is owner" do
      before do
        delete "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token.token}
      end
      it "should have http status 303" do
        expect(response).to have_http_status(303)
      end
    end

    context "when the user is owner1" do
      before do
        patch "/api/restaurants/#{restaurant.id}",params:{access_token:owner_token1.token}
      end
      it "should have http status 403" do
        expect(response).to have_http_status(403)
      end
    end
    
    context "when the user is owner with no restaurant found" do
      before do
        delete "/api/restaurants/100",params:{access_token:owner_token.token,restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"0987",owner:owner}}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end

  end

  
end
  
  
