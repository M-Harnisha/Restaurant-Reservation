require 'rails_helper'

RSpec.describe TableBookedsController, type: :controller do

  let(:user) {create(:user)}
  let(:user_account) {create(:account,:for_user,accountable:user)}

  let(:user1) {create(:user)}
  let(:user1_account) {create(:account,:for_user,accountable:user1)}

  let(:owner) {create(:owner)}
  let(:owner_account) {create(:account,:for_owner,accountable:owner)}

  let(:restaurant) {create(:restaurant,owner:owner)}
  let(:table){create(:table,restaurant:restaurant)}
  let(:reservation) {create(:reservation , restaurant:restaurant , user:user)}

  describe "get /tables#table" do

    context "when account is not sign in" do
      before do
         get :table , params: {id:restaurant.id,type:"table"}
      end
      it "should redirect to sign in  page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as owner" do
      before do
        sign_in owner_account
        get :table , params: {id:restaurant.id,type:"table"}
      end
      it "should redirect to root page" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when account is sign in as user" do
      before do
         sign_in user_account
         get :table , params: {id:restaurant.id,type:"table"}
      end
      it "should render table page" do
        expect(response).to render_template(:table)
      end
    end

    context "when account is sign in as user with invalid type" do
        before do
           sign_in user_account
           get :table , params: {id:restaurant.id,type:"rspec"}
        end
        it "should redirect to root path" do
          expect(response).to redirect_to(root_path)
        end
      end

  end


  describe "post /tables#confrim" do

    context "when account is not sign in" do
      before do
        post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-10-02"}}
      end
      it "should redirect to sign in  page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as owner" do
      before do
        sign_in owner_account
        post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-10-02"}}
      end
      it "should redirect to root page" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when account is sign in as user and type as table" do

      before do
        sign_in user_account
        post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-10-02"},table.id.to_s => 1 }
      end
      it "redirect to reservation show path" do
        expect(response).to redirect_to(reservation_show_path)
      end
    end

    context "when account is sign in as user and type as table_food" do

      before do
        sign_in user_account
        post :confrim , params: {id:restaurant.id,type:"table_food",date_id:{date:"2023-10-02"},table.id.to_s => 1 }
      end
      it "contains flash" do
        expect(flash[:notice]).to eq('reserve food now!!')
      end
    end

    context "when account is sign in as user with invalid type" do
        before do
           sign_in user_account
           get :confrim , params: {id:restaurant.id,type:"rspec",date_id:{date:"2023-10-02"}}
        end
        it "should redirect to root path" do
          expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with date in past" do
        before do
           sign_in user_account
           post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-02-02"},table.id.to_s => 1 }
        end
        it "should contain flash" do
          expect(flash[:notice]).to eq("date cant't be in past")
        end
    end

    context "when account is sign in as user with no date is selected" do
        before do
           sign_in user_account
           post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:""},table.id.to_s => 1 }
        end
        it "should contain flash" do
          expect(flash[:notice]).to eq("check whether you have filled all the details..")
        end
    end

    context "when account is sign in as user with no table is selected" do
        before do
           sign_in user_account
           post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-10-02"}}
        end
        it "should contain flash" do
          expect(flash[:notice]).to eq("No tables selected!!")
        end
    end

    context "when account is sign in as user with already booked table" do
        before do
           sign_in user_account
           post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-07-08"},table.id.to_s => 1 }
           post :confrim , params: {id:restaurant.id,type:"table",date_id:{date:"2023-07-08"},table.id.to_s => 1 }
        end
        it "should contain flash" do
          expect(flash[:notice]).to eq("Already booked")
        end
    end

    context "when account is sign in as user with invalid restaurant id" do
        before do
           sign_in user_account
           post :confrim , params: {id:"4",type:"table"}
        end
        it "should contain flash" do
          expect(flash[:notice]).to eq("Invalid restaurant")
        end
    end
  end

  describe "get /table_bookeds#show" do

  context "when account is not sign in" do
    before do
       get :show , params: {id:restaurant.id}
    end
    it "redirect to root path" do
      expect(response).to redirect_to(root_path)
    end
  end

  context "when account is sign in as owner" do
    before do
      sign_in owner_account
       get :show , params: {id:restaurant.id}
    end
    it "render show page" do
      expect(response).to render_template(:show)
    end
  end

  context "when account is sign in as user" do
    before do 
      sign_in user_account
      get :show , params: {id:restaurant.id}
    end
    it "render show page" do
      expect(response).to render_template(:show)
    end
  end

end

describe "get /table_bookeds#edit" do

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

  describe "patch /table_bookeds#update" do

    context "when account is not sign in" do
      before do
          patch :update ,  params:{id:restaurant.id,reservation_id:reservation.id}
      end
      it "should redirect to sign in page" do
      expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            patch :update ,  params:{id:restaurant.id,reservation_id:reservation.id,table_book:table.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Updated successfully")
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            patch :update,  params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            patch :update,  params:{id:restaurant.id,reservation_id:reservation.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            patch :update , params:{id:'a',reservation_id:'d'}
        end
        it "redirect to root path" do
            expect(response).to redirect_to(root_path)
        end
    end
  end

  describe "delete /table_bookeds#destroy_each" do

    context "when account is not sign in" do
        before do
            delete :destroy_each , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
        end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            delete :destroy_each , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Deleted successfully")
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            delete :destroy_each , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            delete :destroy_each , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            delete :destroy_each , params:{id:'b',reservation_id:'a',table_id:table.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end
  end

  describe "delete /table_bookeds#destroy" do

    context "when account is not sign in" do
        before do
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to sign in page" do
            expect(response).to redirect_to(new_account_session_path)
        end
    end

    context "when account is sign in as user" do
        before do
            sign_in user_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Deleted successfully")
        end
    end

    context "when account is sign in as owner" do
        before do
            sign_in owner_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user1" do
        before do
            sign_in user1_account
            delete :destroy , params:{id:restaurant.id,reservation_id:reservation.id,table_id:table.id}
        end
        it "should redirect to root" do
            expect(response).to redirect_to(root_path)
        end
    end

    context "when account is sign in as user with invalid params" do
        before do
            sign_in user_account
            delete :destroy , params:{id:'b',reservation_id:'a',table_id:table.id}
        end
        it "should contain flash" do
            expect(flash[:notice]).to eq("Not found!..")
        end
    end
  end

end