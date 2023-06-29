require 'rails_helper'

RSpec.describe Owner, type: :model do

  describe "Validation on food_service_id field" do

    context "when food_service_id is nil" do
      let(:owner){build(:owner,food_service_id:nil)}
      before do
        owner.validate
      end
      it "should return false" do
        expect(owner.errors).to include(:food_service_id)
      end
    end

    context "when food_service_id is empty" do
      let(:owner){build(:owner,food_service_id:"")}
      before do
        owner.validate
      end
      it "should return false" do
        expect(owner.errors).to include(:food_service_id)
      end
    end

    context "when food_service_id length is less than 14 " do
      let(:owner){build(:owner,food_service_id:"123")}
      before do
        owner.validate
      end
      it "should return false" do
        expect(owner.errors).to include(:food_service_id)
      end
    end

    context "when food_service length is higher than 14 " do
      let(:owner){build(:owner,food_service_id:"1234567890124569")}
      before do
        owner.validate
      end
      it "should return false" do
        expect(owner.errors).to include(:food_service_id)
      end
    end

    context "when food_service_id contains other characters" do
      let(:owner){build(:owner,food_service_id:"9856p$66414569")}
      before do
        owner.validate
      end
      it "should return false" do
        expect(owner.errors).to include(:food_service_id)
      end
    end

    context "when food_service_id length is 14 " do
      let(:owner){build(:owner)}
      before do
        owner.validate
      end
      it "should return true" do
        expect(owner.errors).to_not include(:food_service_id)
      end
    end

   end
end
