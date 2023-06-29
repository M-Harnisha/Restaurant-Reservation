require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  let(:user) {create(:user)}
  let(:user_account) {create(:account,:for_user,accountable:user)}

  let(:user1) {create(:user)}
  let(:user1_account) {create(:account,:for_user,accountable:user1)}

  let(:owner) {create(:owner)}
  let(:owner_account) {create(:account,:for_owner,accountable:owner)}

  let(:restaurant) {create(:restaurant,owner:owner)}
  let(:menu){create(:menu_item,restaurant:restaurant)}
  let(:reservation) {create(:reservation , restaurant:restaurant , user:user)}
  let!(:order){create(:order,reservation:reservation)}
  let(:order_item) {create(:order_item,order:order)}

  describe "get /orders#food" do

    context "when account is not sign in" do
      before do
        get :food , params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to sign in  page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as owner" do
      before do
        sign_in owner_account
        get :food ,params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to root page" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when account is sign in as user" do
      before do
         sign_in user_account
         get :food , params:{id:restaurant.id,reservation_id:'nil'}
      end
      it "should render food page" do
        expect(response).to render_template(:food)
      end
    end

    context "when account is sign in as user with invalid type" do
      before do
        sign_in user_account
        get :food , params:{id:restaurant.id,reservation_id:'a'}
      end
      it "contains flash" do
        expect(flash[:notice]).to eq("Not found!..")
      end
    end

  end

  describe "post /order#confrim" do

  context "when account is not sign in" do
    before do
      post :confrim ,params:{id:restaurant.id,reservation_id:reservation.id}
    end
    it "should redirect to sign in  page" do
      expect(response).to redirect_to(new_account_session_path)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
      post :confrim ,params:{id:restaurant.id,reservation_id:reservation.id}
    end
    it "should redirect to root page" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as user" do

    before do
      sign_in user_account
      post :confrim ,params:{id:restaurant.id,reservation_id:reservation.id , menu.id.to_s=>1 , quantity:{menu.id.to_s=>"5"}}
    end
    it "contains flash" do
      expect(flash[:notice]).to eq('Order placed successfully')
    end
  end

  context "when account is sign in as user with invalid details" do

    before do
      sign_in user_account
      post :confrim ,params:{id:restaurant.id,reservation_id:'a'}
    end
    it "contains flash" do
      expect(flash[:notice]).to eq('Not found!..')
    end
  end

  context "when account is sign in as user with no quantity is given" do

    before do
      sign_in user_account
      post :confrim ,params:{id:restaurant.id,reservation_id:reservation.id,menu.id.to_s=>1 , quantity:{menu.id.to_s=>""}}
    end
    it "contains flash" do
      expect(flash[:notice]).to eq('Enter details correctly')
    end
  end

  context "when account is sign in as user with no menu is selected" do

    before do
      sign_in user_account
      post :confrim ,params:{id:restaurant.id,reservation_id:reservation.id,quantity:{menu.id.to_s=>"5"}}
    end
    it "contains flash" do
      expect(flash[:notice]).to eq('Enter details correctly')
    end
  end

  
end

describe "get /orders#edit" do

  context "when account is not sign in" do
      before do
          get :edit , params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to sign in page" do
          expect(response).to redirect_to(new_account_session_path)
      end
  end

  context "when account is sign in as owner" do
      before do
          sign_in owner_account
          get :edit, params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "redirect to root path" do
          expect(response).to redirect_to(root_path)
      end
  end

  context "when account is sign in as user" do
      before do
          sign_in user_account
          get :edit, params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "render edit page" do
          expect(response).to render_template(:edit)
      end
  end
  
  context "when account is sign in as user1" do
      before do
          sign_in user1_account
          get :edit , params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to root" do
          expect(response).to redirect_to(root_path)
      end
  end

  context "when account is sign in as user with invalid params" do
    before do
        sign_in user_account
        get :edit, params:{id:restaurant.id,reservation_id:'a'}
    end
    it "should contain flash" do
        expect(flash[:notice]).to eq("Not found!..")
    end
  end
  end

  describe "delete /orders#destroy" do

    context "when account is not sign in" do
        before do
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
        end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Deleted successfully")
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            delete :destroy , params:{id:'b',reservation_id:'a'}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end
  end
end