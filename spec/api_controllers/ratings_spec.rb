require 'rails_helper'

RSpec.describe Api::RatingsController , type: :request do

    let(:user) {create(:user)}
    let(:user_account) {create(:account,:for_user,accountable:user)}
  
    let(:owner) {create(:owner)}
    let(:owner_account) {create(:account,:for_owner,accountable:owner)}
  
    let(:user1) {create(:user)}
    let(:user1_account) {create(:account,:for_user,accountable:user1)}
  
    let!(:restaurant) {create(:restaurant,owner:owner)}
    let!(:reservation) {create(:reservation,restaurant:restaurant,user:user)}

    let!(:order) {create(:order,reservation:reservation)}
    let!(:order_item) {create(:order_item,order:order,menu_id:menu.id)}
    let!(:menu) {create(:menu_item,restaurant:restaurant)}
    let(:user_token) {create(:doorkeeper_access_token,resource_owner_id:user_account.id)}
    let(:owner_token) {create(:doorkeeper_access_token,resource_owner_id:owner_account.id)}
    let(:user_token1) {create(:doorkeeper_access_token,resource_owner_id:user1_account.id)}

    describe "post create" do

        context "when there is no access token" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/rating_create"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/rating_create" , params:{access_token:user_token.token,restaurant.id.to_s=>"100", menu.id.to_s=>"50" }
          end
          it "should have http status 201" do
            expect(response).to have_http_status(201)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/rating_create" , params:{access_token:owner_token.token,restaurant.id.to_s=>"100", menu.id.to_s=>"50"}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            post "/api/restaurant/a/reservations/#{reservation.id}/rating_create" , params:{access_token:user_token.token,restaurant.id.to_s=>"100", menu.id.to_s=>"50"}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no reservation" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/a/rating_create" , params:{access_token:user_token.token,restaurant.id.to_s=>"100", menu.id.to_s=>"50"}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
     
    end

end