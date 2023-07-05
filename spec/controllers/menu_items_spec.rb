require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
    
    let(:user) {create(:user)}
    let(:user_account) {create(:account,:for_user,accountable:user)}
  
    let(:owner) {create(:owner)}
    let(:owner_account) {create(:account,:for_owner,accountable:owner)}
  
    let(:owner1) {create(:owner)}
    let(:owner1_account) {create(:account,:for_owner,accountable:owner1)}
  
    let(:restaurant) {create(:restaurant,owner:owner)}
    let(:menu) {create(:menu_item,restaurant:restaurant)}

    describe "post /menu_items#create" do

        context "when account is not sign in" do
            before do
                post :create , params:{restaurant_id:restaurant.id}
            end
            it "should redirect to sign in page" do
                expect(response).to redirect_to(new_account_session_path)
            end
        end

        context "when account is sign in as owner" do
            before do
                sign_in owner_account
                menu.destroy
                post :create , params:{restaurant_id:restaurant.id,menu_item:{name:menu.name,quantity:menu.quantity,rate:menu.rate}}
            end
            it "should contain flash" do
                expect(flash[:notice]).to eq("New menu item is created")
            end
        end

        context "when account is sign in as user" do
            before do
                sign_in user_account
                post :create , params:{restaurant_id:restaurant.id}
            end
            it "should redirect to root path" do
                expect(response).to redirect_to(root_path)
            end
        end

        context "when account is sign in as owner with invalid params" do
            before do
                sign_in owner_account
                post :create , params:{restaurant_id:restaurant.id,menu_item:{name:menu.name,quantity:menu.quantity,rate:"a"}}
            end
            it "should render new page" do
                expect(response).to redirect_to(root_path)
            end
        end
    end


    describe "get /menu_items#edit" do

        context "when account is not sign in" do
            before do
                get :edit , params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to sign in page" do
                expect(response).to redirect_to(new_account_session_path)
            end
        end

        context "when account is sign in as owner" do
            before do
                sign_in owner_account
                get :edit, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should render edit page" do
                expect(response).to render_template(:edit)
            end
        end

        context "when account is sign in as user" do
            before do
                sign_in user_account
                get :edit, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end
        
        context "when account is sign in as owner1" do
            before do
                sign_in owner1_account
                get :edit, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end

        context "when account is sign in as owner with invalid params" do
            before do
                sign_in owner_account
                get :edit, params:{restaurant_id:restaurant.id,id:'a'}
            end
            it "should contain flash" do
                expect(flash[:notice]).to eq("Not found!..")
            end
        end
    end

    describe "patch /menu_items#update" do

        context "when account is not sign in" do
            before do
                patch :update , params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
            end
        end

        context "when account is sign in as owner" do
            before do
                sign_in owner_account
                patch :update , params:{restaurant_id:restaurant.id,id:menu.id,menu_item:{name:"Rspec"}}
            end
            it "should contain flash" do
                expect(flash[:notice]).to eq("Updated successfully")
            end
        end

        context "when account is sign in as user" do
            before do
                sign_in user_account
                patch :update, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end

        context "when account is sign in as owner1" do
            before do
                sign_in owner1_account
                patch :update, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end

        context "when account is sign in as owner with invalid params" do
            before do
                sign_in owner_account
                patch :update , params:{restaurant_id:restaurant.id,id:'a'}
            end
            it "should render edit page" do
                expect(response).to render_template(:edit)
            end
        end
    end

    describe "delete /menu_items#destroy" do

        context "when account is not sign in" do
            before do
                delete :destroy , params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to sign in page" do
                expect(response).to redirect_to(new_account_session_path)
            end
        end
    
        context "when account is sign in as owner" do
            before do
                sign_in owner_account
                delete :destroy , params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should contain flash" do
                expect(flash[:notice]).to eq("Destroyed successfully")
            end
        end
    
        context "when account is sign in as user" do
            before do
                sign_in user_account
                delete :destroy, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end
    
        context "when account is sign in as owner1" do
            before do
                sign_in owner1_account
                delete :destroy, params:{restaurant_id:restaurant.id,id:menu.id}
            end
            it "should redirect to root" do
                expect(response).to redirect_to(root_path)
            end
        end
    
        context "when account is sign in as owner with invalid params" do
            before do
                sign_in owner_account
                delete :destroy, params:{restaurant_id:'b',id:'a'}
            end
            it "should contain flash" do
                expect(flash[:notice]).to eq("No restaurant is available with given id")
            end
        end
    end
end