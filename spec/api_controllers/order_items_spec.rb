require 'rails_helper'

RSpec.describe Api::OrderItemsController , type: :request do

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



    describe "delete destroy" do

        context "when there is no access token" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order_item.id}"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order_item.id}", params:{access_token:user_token.token}
          end
          it "should have http status 303" do
            expect(response).to have_http_status(303)
          end
        end

        context "when the user1 is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order_item.id}", params:{access_token:user_token1.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order_item.id}", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no reservation" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/a/order/#{order_item.id}" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no orders" do
            before do
              order_item.destroy
              delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/a", params:{access_token:user_token.token}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
  
      end


      describe "post new" do

        context "when there is no access token" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order.id}/new"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order.id}/new" , params:{access_token:user_token.token ,quantity:{:food =>"5"},order_item:{:menu_id=>menu.id}}
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order.id}/new" , params:{access_token:owner_token.token,quantity:{:food =>"5"},order_item:{:menu_id=>menu.id}}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no order" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/a/new" , params:{access_token:user_token.token,quantity:{:food =>"5"},order_item:{:menu_id=>menu.id}}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no reservation" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/a/order/#{order.id}/new" , params:{access_token:user_token.token,quantity:{:food =>"5"},order_item:{:menu_id=>menu.id}}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
    
        context "when the user is customer with no quantity" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order.id}/new" , params:{access_token:user_token.token ,quantity:{:food =>""},order_item:{:menu_id=>menu.id}}
            end
            it "should have http status 406" do
              expect(response).to have_http_status(406)
            end
        end

        context "when the user is customer with no order item is given" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/order/#{order.id}/new" , params:{access_token:user_token.token ,quantity:{:food =>"5"}}
            end
            it "should have http status 406" do
              expect(response).to have_http_status(406)
            end
        end
        
      end


end