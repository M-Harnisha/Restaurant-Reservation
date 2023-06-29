require 'rails_helper'

RSpec.describe Api::TableBookedsController , type: :request do
    let(:user) {create(:user)}
    let(:user_account) {create(:account,:for_user,accountable:user)}
  
    let(:owner) {create(:owner)}
    let(:owner_account) {create(:account,:for_owner,accountable:owner)}
  
    let(:user1) {create(:user)}
    let(:user1_account) {create(:account,:for_user,accountable:user1)}
  
    let!(:restaurant) {create(:restaurant,owner:owner)}
    let!(:reservation) {create(:reservation,restaurant:restaurant,user:user)}

    let!(:table) {create(:table,restaurant:restaurant)}

    
    let(:user_token) {create(:doorkeeper_access_token,resource_owner_id:user_account.id)}
    let(:owner_token) {create(:doorkeeper_access_token,resource_owner_id:owner_account.id)}
    let(:user_token1) {create(:doorkeeper_access_token,resource_owner_id:user1_account.id)}

    describe "post confrim" do

        context "when there is no access token" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/table/confrim"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:Date.today},table.id.to_s => 1 }
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:owner_token.token,date_id:{date:"2023-10-02"},table.id.to_s => 1 }
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            post "/api/restaurant/a/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-10-02"},table.id.to_s => 1 }
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with invalid type" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/abc/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-10-02"},table.id.to_s => 1 }
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end

        context "when the user is customer with no tables selected" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-10-02"}}
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end
    
        context "when the user is customer with no date selected" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:""},table.id.to_s => 1 }
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end

        context "when the user is customer with date in past" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-02-02"},table.id.to_s => 1 }
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end

        context "when the user is customer with date is already booked" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-10-02"},table.id.to_s => 1 }
              post "/api/restaurant/#{restaurant.id}/reservations/table/confrim" , params:{access_token:user_token.token,date_id:{date:"2023-10-02"},table.id.to_s => 1 }
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end

      end


      describe "post update" do

        context "when there is no access token" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/update"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/update", params:{access_token:user_token.token,table_book:table.id}
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when the user1 is customer" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/update", params:{access_token:user_token1.token,table_book:table.id}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/update", params:{access_token:owner_token.token,table_book:table.id}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            post "/api/restaurant/a/reservations/table/confrim" , params:{access_token:user_token.token,table_book:table.id}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no tables selected" do
            before do
              post "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/update", params:{access_token:user_token.token}
            end
            it "should have http status 422" do
              expect(response).to have_http_status(422)
            end
        end
    

      end

      describe "delete destroy" do

        context "when there is no access token" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            reservation.tables << table
            reservation.save
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}", params:{access_token:user_token.token}
          end
          it "should have http status 303" do
            expect(response).to have_http_status(303)
          end
        end

        context "when the user1 is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}", params:{access_token:user_token1.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no reservation" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/a" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no tables" do
            before do
              delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/b", params:{access_token:user_token.token}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
  
      end

      describe "delete destroy_each" do

        context "when there is no access token" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/#{table.id}"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            reservation.tables << table
            reservation.save
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/#{table.id}", params:{access_token:user_token.token}
          end
          it "should have http status 303" do
            expect(response).to have_http_status(303)
          end
        end

        context "when the user1 is customer" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/#{table.id}", params:{access_token:user_token1.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end
    
        context "when the user is owner" do
          before do
            delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/#{table.id}", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no reservation" do
          before do
            delete "/api/restaurant/#{reservation.id}/reservations/a/#{table.id}" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with no tables" do
            before do
              delete "/api/restaurant/#{restaurant.id}/reservations/#{reservation.id}/b", params:{access_token:user_token.token}
            end
            it "should have http status 404" do
              expect(response).to have_http_status(404)
            end
        end
  
      end


      describe "get table" do

        context "when there is no access token" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/table"
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
    
        context "when the user is customer" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/table", params:{access_token:user_token.token}
          end
          it "should have http status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when the user is owner" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/table", params:{access_token:owner_token.token}
          end
          it "should have http status 403" do
            expect(response).to have_http_status(403)
          end
        end

        context "when the user is customer with no restaurant" do
          before do
            get "/api/restaurant/a/reservations/table" , params:{access_token:user_token.token}
          end
          it "should have http status 404" do
            expect(response).to have_http_status(404)
          end
        end

        context "when the user is customer with invalid type" do
          before do
            get "/api/restaurant/#{restaurant.id}/reservations/abc" , params:{access_token:user_token.token}
          end
          it "should have http status 422" do
            expect(response).to have_http_status(422)
          end
        end
        
      end
end