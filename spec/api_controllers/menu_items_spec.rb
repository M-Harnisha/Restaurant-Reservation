require 'rails_helper'

RSpec.describe Api::MenuItemsController , type: :request do
    let(:user) {create(:user)}
    let(:user_account) {create(:account,:for_user,accountable:user)}
  
    let(:owner) {create(:owner)}
    let(:owner_account) {create(:account,:for_owner,accountable:owner)}
  
    let(:owner1) {create(:owner)}
    let(:owner1_account) {create(:account,:for_owner,accountable:owner1)}
  
    let!(:restaurant) {create(:restaurant,owner:owner)}
    let!(:menu) {create(:menu_item,restaurant:restaurant)}

    
    let(:user_token) {create(:doorkeeper_access_token,resource_owner_id:user_account.id)}
    let(:owner_token) {create(:doorkeeper_access_token,resource_owner_id:owner_account.id)}
    let(:owner_token1) {create(:doorkeeper_access_token,resource_owner_id:owner1_account.id)}
  
    describe "post create" do

        context "when there is no access token" do
          before do
            post "/api/restaurants/#{restaurant.id}/menu_items"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is user" do
          before do
            post "/api/restaurants/#{restaurant.id}/menu_items" , params:{access_token:user_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurants/#{restaurant.id}/menu_items" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 201" do
            expect(response).to have_http_status(201)
          end
        end

        context "when the user is owner1" do
            before do
              post "/api/restaurants/#{restaurant.id}/menu_items" , params:{access_token:owner_token1.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should have http status 403" do
              expect(response).to have_http_status(403)
            end
          end
    
        context "when the user is owner with no restaurant" do
          before do
            post "/api/restaurants/100/menu_items" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is owner with wrong params" do
            before do
              post "/api/restaurants/#{restaurant.id}/menu_items" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:'hh',rate:menu.rate}}
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
          end
    
      end

      describe "patch update" do

        context "when there is no access token" do
          before do
            patch "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is user" do
          before do
            patch "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:user_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            patch "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when the user is owner1" do
            before do
              patch "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:owner_token1.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should have http status 403" do
              expect(response).to have_http_status(403)
            end
          end
    
        context "when the user is owner with no restaurant" do
          before do
            patch "/api/restaurants/100/menu_items/#{menu.id}" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is owner with no menus" do
            before do
              patch "/api/restaurants/#{restaurant.id}/menu_items/100" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
          end

        context "when the user is owner with wrong params" do
            before do
              patch "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:'hh',rate:menu.rate}}
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
          end
    
      end

      describe "delete destroy" do

        context "when there is no access token" do
          before do
            delete "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is user" do
          before do
            delete "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:user_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            delete "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 303" do
            expect(response).to have_http_status(303)
          end
        end

        context "when the user is owner1" do
            before do
              delete "/api/restaurants/#{restaurant.id}/menu_items/#{menu.id}" , params:{access_token:owner_token1.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should have http status 403" do
              expect(response).to have_http_status(403)
            end
          end
    
        context "when the user is owner with no restaurant" do
          before do
            delete "/api/restaurants/100/menu_items/#{menu.id}" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is owner with no menus" do
            before do
              delete "/api/restaurants/#{restaurant.id}/menu_items/100" , params:{access_token:owner_token.token,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
          end

    
      end
end