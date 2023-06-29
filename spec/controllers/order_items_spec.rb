require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  
    let(:user) {create(:user)}
    let(:user_account) {create(:account,:for_user,accountable:user)}
  
    let(:user1) {create(:user)}
    let(:user1_account) {create(:account,:for_user,accountable:user1)}
  
    let(:owner) {create(:owner)}
    let(:owner_account) {create(:account,:for_owner,accountable:owner)}
  
    let(:restaurant) {create(:restaurant,owner:owner)}
    let(:reservation) {create(:reservation , restaurant:restaurant , user:user)}
    let(:order){create(:order,reservation:reservation)}
    let(:menu) {create(:menu_item , restaurant:restaurant)}
    let(:order_item){create(:order_item,order:order,menu_id:menu.id)}
    
    describe "post /order_items#new" do

    context "when account is not sign in" do
        before do
            post :new , params:{id:restaurant.id,reservation_id:reservation.id,order_id:order.id}
        end
        it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            post :new, params:{id:restaurant.id,reservation_id:reservation.id,order_id:order.id}
        end
        it "redirect to root path" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            post :new, params:{id:restaurant.id,reservation_id:reservation.id,order_id:order.id,quantity:{:food =>"5"},order_item:{:menu_id=>menu.id}}
        end
        it "reidrect to show reservation page" do
            expect(response).to redirect_to(reservation_show_path)
        end
    end
    
    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            post :new , params:{id:restaurant.id,reservation_id:reservation.id,order_id:order.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            post :new, params:{id:restaurant.id,reservation_id:'a',order_id:order.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end

    context "when account is sign in as user with no order is selected" do
        before do
            sign_in user_account
            post :new, params:{id:restaurant.id,reservation_id:'a',order_id:order.id,quantity:{:food =>"5"}}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end

    context "when account is sign in as user with no quantity is given" do
        before do
            sign_in user_account
            post :new, params:{id:restaurant.id,reservation_id:'a',order_id:order.id,quantity:{:food =>""},order_item:{:menu_id=>menu.id}}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end

  end

  describe "delete /order_items#destroy" do

    context "when account is not sign in" do
        before do
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,order_item_id:order_item.id}
        end
        it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
        end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,order_item_id:order_item.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Deleted successfully")
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,order_item_id:order_item.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,order_item_id:order_item.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            delete :destroy , params:{id:'b',reservation_id:'a',order_item_id:order_item.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end
  end
end