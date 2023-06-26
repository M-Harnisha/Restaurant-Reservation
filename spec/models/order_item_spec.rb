require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "Validation on Name Field" do

    context "when name field is nil" do
       let(:order_item) {build(:order_item,name:nil)}
        before do
          order_item.save
        end
        it "should return false" do
          expect(order_item.errors).to include(:name)
        end
    end
  
    context "when name field is empty" do
      let(:order_item) {build(:order_item,name:"")}
       before do
         order_item.save
       end
       it "should return false" do
         expect(order_item.errors).to include(:name)
       end
    end

    context "when name field is less than 3" do
      let(:order_item) {build(:order_item,name:"hr")}
        before do
          order_item.save
        end
        it "should return false" do
          expect(order_item.errors).to include(:name)
        end
    end

    context "when name field is greater than 15" do
    let(:order_item) {build(:order_item,name:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
        before do
        order_item.save
        end
        it "should return false" do
        expect(order_item.errors).to include(:name)
        end
    end

    context "when name field is between 3 and  15" do
    let(:order_item) {build(:order_item)}
        before do
        order_item.save
        end
        it "should return true" do
        expect(order_item.errors).to_not include(:name)
        end
    end
    
end

describe "Validation on quantity field" do

    context "when quantity is nil" do
      let(:order_item){build(:order_item,quantity:nil)}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:quantity)
      end
    end

    context "when quantity is empty" do
      let(:order_item){build(:order_item,quantity:"")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:quantity)
      end
    end

    context "when quantity is less than 0" do
      let(:order_item){build(:order_item,quantity:"-1")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:quantity)
      end
    end

    context "when quantity is equal to 0" do
        let(:order_item){build(:order_item,quantity:"0")}
        before do
          order_item.save
        end
        it "should return false" do
          expect(order_item.errors).to include(:quantity)
        end
      end

    context "when quantity contains other characters" do
      let(:order_item){build(:order_item,quantity:"9p")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:quantity)
      end
    end

    context "when quantity is greater than 0" do
        let(:order_item){build(:order_item)}
        before do
          order_item.save
        end
        it "should return true" do
          expect(order_item.errors).to_not include(:quantity)
        end
    end

end

describe "Validation on rate field" do

    context "when rate is nil" do
      let(:order_item){build(:order_item,rate:nil)}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:rate)
      end
    end

    context "when rate is empty" do
      let(:order_item){build(:order_item,rate:"")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:rate)
      end
    end

    context "when rate is less than 0" do
      let(:order_item){build(:order_item,rate:"-1")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:rate)
      end
    end

    context "when rate is equal to 0" do
        let(:order_item){build(:order_item,rate:"0")}
        before do
          order_item.save
        end
        it "should return false" do
          expect(order_item.errors).to include(:rate)
        end
      end

    context "when rate contains other characters" do
      let(:order_item){build(:order_item,rate:"9p")}
      before do
        order_item.save
      end
      it "should return false" do
        expect(order_item.errors).to include(:rate)
      end
    end

    context "when rate is greater than 0" do
        let(:order_item){build(:order_item)}
        before do
          order_item.save
        end
        it "should return true" do
          expect(order_item.errors).to_not include(:rate)
        end
    end

end

describe "Validation on menu_id field" do

  context "when menu_id is nil" do
    let(:order_item){build(:order_item,menu_id:nil)}
    before do
      order_item.save
    end
    it "should return false" do
      expect(order_item.errors).to include(:menu_id)
    end
  end

  context "when menu_id is empty" do
    let(:order_item){build(:order_item,menu_id:"")}
    before do
      order_item.save
    end
    it "should return false" do
      expect(order_item.errors).to include(:menu_id)
    end
  end

  context "when menu_id is not integer" do
    let(:order_item){build(:order_item,menu_id:"pq")}
    before do
      order_item.save
    end
    it "should return false" do
      expect(order_item.errors).to include(:menu_id)
    end
  end

  context "when menu_id is less than 0" do
    let(:order_item){build(:order_item,menu_id:"-1")}
    before do
      order_item.save
    end
    it "should return false" do
      expect(order_item.errors).to include(:menu_id)
    end
  end

  context "when menu_id is greater than 0" do
    let(:order_item){build(:order_item,menu_id:"5")}
    before do
      order_item.save
    end
    it "should return true" do
      expect(order_item.errors).to_not include(:menu_id)
    end
  end
end

describe "association" do

    context "belongs_to"  do
      let(:order) {create(:order)}
      let(:order_item) {build(:order_item , order:order)}
      it "return order_item is true" do
        expect(order_item.order).to be_an_instance_of(Order)
      end
    end
    
  end
end
