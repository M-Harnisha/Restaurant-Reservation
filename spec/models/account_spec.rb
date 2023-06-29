require 'rails_helper'

RSpec.describe Account, type: :model do

  describe "Validation on Name Field" do

    context "when name field is nil" do
       let(:account) {build(:account,name:nil)}
        before do
          account.validate
        end
        it "should return false" do
          expect(account.errors).to include(:name)
        end
    end
  
    context "when name field is empty" do
      let(:account) {build(:account,name:"")}
       before do
         account.validate
       end
       it "should return false" do
         expect(account.errors).to include(:name)
       end
    end

    context "when name field is less than 5" do
      let(:account) {build(:account,name:"har")}
        before do
          account.validate
        end
        it "should return false" do
          expect(account.errors).to include(:name)
        end
      end

      context "when name field is greater than 15" do
        let(:account) {build(:account,name:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
          before do
            account.validate
          end
          it "should return false" do
            expect(account.errors).to include(:name)
          end
      end

      context "when name field is between 5 and  15" do
        let(:account) {build(:account)}
          before do
            account.validate
          end
          it "should return true" do
            expect(account.errors).to_not include(:name)
          end
      end
  end

  describe "Validation on email field" do

    before(:each) do
      account.validate
    end

    context "when email is nill" do
      let(:account) {build(:account,email:nil)}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is in wrong format" do
      let(:account) {build(:account,email:"hari")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is empty" do
      let(:account) {build(:account,email:"")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is correct" do
      let(:account) {build(:account)}
      before do
        account.validate
      end
      it "should return true" do
        expect(account.errors).to_not include(:email)
      end
    end

   end

   describe "Validation on contact field" do

    context "when contact is nil" do
      let(:account){build(:account,contact:nil)}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact is empty" do
      let(:account){build(:account,contact:"")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact length is less than 10 " do
      let(:account){build(:account,contact:"123")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact length is higher than 10 " do
      let(:account){build(:account,contact:"123456789012")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact contains other characters" do
      let(:account){build(:account,contact:"9856p$6641")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact only contains zero" do
      let(:account){build(:account,contact:"0000000000")}
      before do
        account.validate
      end
      it "should return false" do
        expect(account.errors).to include(:contact)
      end
    end

    context "when contact length is 10 " do
      let(:account){build(:account)}
      before do
        account.validate
      end
      it "should return true" do
        expect(account.errors).to_not include(:contact)
      end
    end

   end

   describe "Validation on Password field" do

    context "when password is nil" do
      let(:account) {build(:account,password:nil,password_confirmation:nil)}

      before do
        account.validate
      end

      it "should return false" do
        expect(account.errors).to include(:password)
      end
    end

    context "when password is empty" do
      let(:account) {build(:account,password:"",password_confirmation:"")}

      before do
        account.validate
      end

      it "should return false" do
        expect(account.errors).to include(:password)
      end
    end

    context "when password is less than 6 charaters" do
      let(:account) {build(:account,password:"123",password_confirmation:"123")}

      before do
        account.validate
      end

      it "should return false" do
        expect(account.errors).to include(:password)
      end
    end

    context "when password doesnot matches password confirmation" do

      let(:account) {build(:account,password:"123456",password_confirmation:"1234567")}

      before do
        account.validate
      end

      it "should return false" do
        expect(account.errors).to include(:password_confirmation)
      end
    end

    context "when password is greater than or equal to 6 charaters" do
      let(:account) {build(:account)}

      before do
        account.validate
      end

      it "should return true" do
        expect(account.errors).to_not include(:password)
      end
    end

  end

  describe "association" do

    context "belongs_to" do
      let(:account) {create(:account , :for_user)}
      it "should be instance of user" do
        expect(account.accountable).to be_an_instance_of(User)
      end
    end

    context "belongs_to" do
      let(:account) {create(:account , :for_owner)}
       
      it "should be instance of owner" do
        expect(account.accountable).to be_an_instance_of(Owner)
      end
    end

  end

end
