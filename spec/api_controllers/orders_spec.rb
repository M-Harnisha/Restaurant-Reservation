require 'rails_helper'

RSpec.describe Api::OrdersController , type: :request do
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

    describe "post confrim" do

        context "when there is no access token" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food/confrim"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food/confrim" , params:{access_token:user_token.token,menu.id.to_s=>1 , quantity:{menu.id.to_s=>"5"} }
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food/confrim" , params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            post "/api/restaurant/a/reservations/#{reservation.id}/food/confrim" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no reservation" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/a/food/confrim" , params:{access_token:user_token.token}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
    
        context "when the user is customer with no menu item" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/a/food/confrim" , params:{access_token:user_token.token , quantity:{menu.id.to_s=>"10"} }
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
        
        context "when the user is customer with no quantity" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/a/food/confrim" , params:{access_token:user_token.token ,menu.id.to_s=>1 , quantity:{menu.id.to_s=>""}}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
        
      end

      describe "get food" do

        context "when there is no access token" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food", params:{access_token:user_token.token}
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when the user is owner" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            get "/api/restaurant/a/reservations/#{reservation.id}/food" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no menus" do
            before do
              MenuItem.destroy_all
              get "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/food" , params:{access_token:user_token.token }
            end
            it "should have http status 204" do
              expect(response).to have_http_status(204)
            end
        end
      end

      describe "delete destroy" do

        context "when there is no access token" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order", params:{access_token:user_token.token}
          end
          it "should have http status 303" do
            expect(response).to have_http_status(303)
          end
        end

        context "when the user1 is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order", params:{access_token:user_token1.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no reservation" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/a/order" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no orders" do
            before do
              order_item.destroy
              delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order", params:{access_token:user_token.token}
            end
            it "should have http status 204" do
              expect(response).to have_http_status(204)
            end
        end
  
      end
end