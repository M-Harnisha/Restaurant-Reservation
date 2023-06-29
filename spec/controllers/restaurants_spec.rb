require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do

  let(:user) {create(:user)}
  let(:user_account) {create(:account,:for_user,accountable:user)}

  let(:owner) {create(:owner)}
  let(:owner_account) {create(:account,:for_owner,accountable:owner)}

  let(:owner1) {create(:owner)}
  let(:owner1_account) {create(:account,:for_owner,accountable:owner1)}

  let(:restaurant) {create(:restaurant,owner:owner)}

  describe "get /restaurants#index" do

    context "when account is not sign in" do
      before do
         get :index
      end
      it "should render index page" do
        expect(response).to render_template(:index)
      end
    end

    context "when account is sign in as owner" do
      before do
        sign_in owner_account
         get :index
      end
      it "should render index page" do
        expect(response).to render_template(:index)
      end
    end

    context "when account is sign in as user" do
      before do
        sign_in user_account
         get :index
      end
      it "should render index page" do
        expect(response).to render_template(:index)
      end
    end

  end

  describe "get /restaurants#show" do

  context "when account is not sign in" do
    before do
       get :show , params: {id:restaurant.id}
    end
    it "should render show page" do
      expect(response).to render_template(:show)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
       get :show , params: {id:restaurant.id}
    end
    it "should render show page" do
      expect(response).to render_template(:show)
    end
  end

  context "when account is sign in as user" do
    before do 
      sign_in user_account
      get :show , params: {id:restaurant.id}
    end
    it "should render show page" do
      expect(response).to render_template(:show)
    end
  end

  context "when account is signed in and params is invalid" do
    before do
      sign_in user_account
      get :show ,params: {id:'a'}
    end
    it "should redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end
  
end

  describe "get /restaurants#new" do

    context "when account is not sign in" do
      before do
         get :new
      end
      it "should redirect to sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as owner" do
      before do
         sign_in owner_account
         get :new
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end

    context "when account is sign in as user" do
      before do
        sign_in user_account
        get :new
      end
      it "should redirect to root" do
        expect(response).to redirect_to(root_path)
      end
    end
    
  end

  
  describe "post /restaurants#create" do

    context "when account is not sign in" do
      before do
         post :create
      end
      it "should redirect to sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as owner" do
      before do
        sign_in owner_account
        post :create , params:{restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:restaurant.contact,owner:owner}}
      end
      it "should contain flash" do
        expect(flash[:notice]).to eq("Created New Restaurant")
      end
    end

    context "when account is sign in as user" do
      before do
        sign_in user_account
        post :create
      end
      it "should redirect to root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when account is sign in as owner with invalid params" do
      before do
        sign_in owner_account
        post :create , params:{restaurant:{name:restaurant.name,address:restaurant.address,city:restaurant.city,contact:"0987a",owner:owner}}
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "get /restaurants#edit" do

  context "when account is not sign in" do
    before do
       get :edit , params:{id:restaurant.id}
    end
    it "should redirect to sign in page" do
      expect(response).to redirect_to(new_account_session_path)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
       get :edit, params:{id:restaurant.id}
    end
    it "should render edit page" do
      expect(response).to render_template(:edit)
    end
  end

  context "when account is sign in as user" do
    before do
      sign_in user_account
      get :edit, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end
  
  context "when account is sign in as owner1" do
    before do
       sign_in owner1_account
       get :edit, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner with invalid params" do
    before do
      sign_in owner_account
       get :edit, params:{id:'a'}
    end
    it "should redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end
end

describe "patch /restaurants#update" do

  context "when account is not sign in" do
    before do
      patch :update , params:{id:restaurant.id}
    end
    it "should redirect to sign in page" do
      expect(response).to redirect_to(new_account_session_path)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
      patch :update, params:{id:restaurant.id,restaurant:{name:"Rspec"}}
    end
    it "should contain flash" do
      expect(flash[:notice]).to eq("Updated successfully")
    end
  end

  context "when account is sign in as user" do
    before do
      sign_in user_account
      patch :update, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner1" do
    before do
      sign_in owner1_account
      patch :update, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner with invalid params" do
    before do
      sign_in owner_account
      patch :update, params:{id:'a'}
    end
    it "should redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end
end

describe "delete /restaurants#destroy" do

  context "when account is not sign in" do
    before do
      delete :destroy , params:{id:restaurant.id}
    end
    it "should redirect to sign in page" do
      expect(response).to redirect_to(new_account_session_path)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
      delete :destroy, params:{id:restaurant.id}
    end
    it "should redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as user" do
    before do
      sign_in user_account
      delete :destroy, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner1" do
    before do
      sign_in owner1_account
      delete :destroy, params:{id:restaurant.id}
    end
    it "should redirect to root" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner with invalid params" do
    before do
      sign_in owner_account
      delete :destroy, params:{id:'a'}
    end
    it "should redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end
end

end