require 'rails_helper'

RSpec.describe Restaurant, type: :model do
 
  describe "Validation on Name Field" do

    context "when name field is nil" do
       let(:restaurant) {build(:restaurant,name:nil)}
        before do
          restaurant.validate
        end
        
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("Name can't be blank")
        end
    end
  
    context "when name field is empty" do
      let(:restaurant) {build(:restaurant,name:"")}
       before do
         restaurant.validate
       end
       it "should return false" do
         expect(restaurant.errors.full_messages).to include("Name can't be blank")
       end
    end

    context "when name field is less than 3" do
      let(:restaurant) {build(:restaurant,name:"ha")}
        before do
          restaurant.validate
        end
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("Name is too short (minimum is 3 characters)")
        end
      end

      context "when name field is greater than 25" do
        let(:restaurant) {build(:restaurant,name:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
          before do
            restaurant.validate
          end
          it "should return false" do
            expect(restaurant.errors.full_messages).to include("Name is too long (maximum is 25 characters)")
          end
      end

      context "when name field is between 3 and  25" do
        let(:restaurant) {build(:restaurant)}
          before do
            restaurant.validate
          end
          it "should return true" do
            expect(restaurant.errors.full_messages).to_not include(:name)
          end
      end
  end

  describe "Validation on contact field" do

    context "when contact is nil" do
      let(:restaurant){build(:restaurant,contact:nil)}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact can't be blank")
      end
    end

    context "when contact is empty" do
      let(:restaurant){build(:restaurant,contact:"")}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact can't be blank")
      end
    end

    context "when contact length is less than 10 " do
      let(:restaurant){build(:restaurant,contact:"123")}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact is too short (minimum is 10 characters)")
      end
    end

    context "when contact length is higher than 10 " do
      let(:restaurant){build(:restaurant,contact:"123456789012")}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact is too long (maximum is 10 characters)")
      end
    end

    context "when contact contains other characters" do
      let(:restaurant){build(:restaurant,contact:"9856p$6641")}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact is not a number")
      end
    end

    context "when contact only contains zero" do
      let(:restaurant){build(:restaurant,contact:"0000000000")}
      before do
        restaurant.validate
      end
      it "should return false" do
        expect(restaurant.errors.full_messages).to include("Contact must be greater than 0")
      end
    end

    context "when contact length is 10 " do
      let(:restaurant){build(:restaurant)}
      before do
        restaurant.validate
      end
      it "should return true" do
        expect(restaurant.errors.full_messages).to_not include(:contact)
      end
    end

   end

   describe "Validation on address Field" do

    context "when address field is nil" do
       let(:restaurant) {build(:restaurant,address:nil)}
        before do
          restaurant.validate
        end
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("Address can't be blank")
        end
    end
  
    context "when address field is empty" do
      let(:restaurant) {build(:restaurant,address:"")}
       before do
         restaurant.validate
       end
       it "should return false" do
         expect(restaurant.errors.full_messages).to include("Address can't be blank")
       end
    end

    context "when address field is less than 5" do
      let(:restaurant) {build(:restaurant,address:"har")}
        before do
          restaurant.validate
        end
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("Address is too short (minimum is 5 characters)")
        end
      end

      context "when address field is greater than 30" do
        let(:restaurant) {build(:restaurant,address:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
          before do
            restaurant.validate
          end
          it "should return false" do
            expect(restaurant.errors.full_messages).to include("Address is too long (maximum is 30 characters)")
          end
      end

      context "when address field is between 5 and  30" do
        let(:restaurant) {build(:restaurant)}
          before do
            restaurant.validate
          end
          it "should return true" do
            expect(restaurant.errors.full_messages).to_not include(:address)
          end
      end
  end

  
  describe "Validation on city Field" do

    context "when city field is nil" do
       let(:restaurant) {build(:restaurant,city:nil)}
        before do
          restaurant.validate
        end
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("City can't be blank")
        end
    end
  
    context "when city field is empty" do
      let(:restaurant) {build(:restaurant,city:"")}
       before do
         restaurant.validate
       end
       it "should return false" do
         expect(restaurant.errors.full_messages).to include("City can't be blank")
       end
    end

    context "when city field is less than 4" do
      let(:restaurant) {build(:restaurant,city:"har")}
        before do
          restaurant.validate
        end
        it "should return false" do
          expect(restaurant.errors.full_messages).to include("City is too short (minimum is 4 characters)")
        end
      end

      context "when city field is greater than 15" do
        let(:restaurant) {build(:restaurant,city:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
          before do
            restaurant.validate
          end
          it "should return false" do
            expect(restaurant.errors.full_messages).to include("City is too long (maximum is 15 characters)")
          end
      end

      context "when city field is between 4 and  15" do
        let(:restaurant) {build(:restaurant)}
          before do
            restaurant.validate
          end
          it "should return true" do
            expect(restaurant.errors.full_messages).to_not include(:city)
          end
      end
  end

  describe "association" do

    context "belongs_to"  do
      let(:owner) {create(:owner)}
      let(:restaurant) {build(:restaurant , owner:owner)}
      it "return restaurant is true" do
        expect(restaurant.owner).to be_an_instance_of(Owner)
      end
    end
    
  end

end
