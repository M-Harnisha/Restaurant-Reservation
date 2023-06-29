require 'rails_helper'

RSpec.describe RatingsController, type: :controller do

  let(:user) {create(:user)}
  let(:user_account) {create(:account,:for_user,accountable:user)}

  let(:user1) {create(:user)}
  let(:user1_account) {create(:account,:for_user,accountable:user1)}

  let(:owner) {create(:owner)}
  let(:owner_account) {create(:account,:for_owner,accountable:owner)}

  let(:restaurant) {create(:restaurant,owner:owner)}
  let(:menu){create(:menu_item,restaurant:restaurant)}
  let!(:reservation) {create(:reservation , restaurant:restaurant , user:user)}
  let!(:order) {create(:order,reservation:reservation)}
  let!(:order_item) {create(:order_item, order:order, menu_id:menu.id)}


  describe "post /ratings#create" do

  context "when account is not sign in" do
      before do
          post :create , params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to sign in page" do
          expect(response).to redirect_to(new_account_session_path)
      end
  end

  context "when account is sign in as owner" do
      before do
          sign_in owner_account
          post :create, params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "redirect to root path" do
          expect(response).to redirect_to(root_path)
      end
  end

  context "when account is sign in as user" do
      before do
          sign_in user_account
          post :create, params:{id:restaurant.id,reservation_id:reservation.id, restaurant.id.to_s=>"100", menu.id.to_s=>"50"}
      end
      it "redirect to reservation show path" do
          expect(response).to redirect_to(reservation_show_path )
      end
  end
  
  context "when account is sign in as user1" do
      before do
          sign_in user1_account
          post :create , params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to root" do
          expect(response).to redirect_to(root_path)
      end
  end

  context "when account is sign in as user with invalid params" do
    before do
        sign_in user_account
        post :create, params:{id:restaurant.id,reservation_id:'a'}
    end
    it "should contain flash" do
        expect(flash[:notice]).to eq("Not found!..")
    end
  end
  end
end