require 'rails_helper'

RSpec.describe Rating, type: :model do
  
  describe "Validation on value field" do

    context "when value is nil" do
      let(:rating){build(:rating,value:nil)}
      before do
        rating.save
      end
      it "should return false" do
        expect(rating.errors).to include(:value)
      end
    end

    context "when value is empty" do
      let(:rating){build(:rating,value:"")}
      before do
        rating.save
      end
      it "should return false" do
        expect(rating.errors).to include(:value)
      end
    end

    context "when value is less than 0" do
      let(:rating){build(:rating,value:"-1")}
      before do
        rating.save
      end
      it "should return false" do
        expect(rating.errors).to include(:value)
      end
    end


    context "when value contains other characters" do
      let(:rating){build(:rating,value:"9p")}
      before do
        rating.save
      end
      it "should return false" do
        expect(rating.errors).to include(:value)
      end
    end

    context "when value is greater than 100" do
        let(:rating){build(:rating,value:"10000")}
        before do
          rating.save
        end
        it "should return false" do
          expect(rating.errors).to include(:value)
        end
    end

    context "when value is between 0 and 100" do
      let(:rating){build(:rating)}
      before do
        rating.save
      end
      it "should return true" do
        expect(rating.errors).to_not include(:value)
      end
  end

end

describe "association" do

    context "belongs_to" do
      let(:rating) {create(:rating , :for_restaurant)}
      it "should be instance of restaurant" do
        expect(rating.rateable).to be_an_instance_of(Restaurant)
      end
    end

    context "belongs_to" do
      let(:rating) {create(:rating , :for_menu_item)}
       
      it "should be instance of menu_item" do
        expect(rating.rateable).to be_an_instance_of(MenuItem)
      end
    end

  end


end
