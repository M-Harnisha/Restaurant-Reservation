require 'rails_helper'

RSpec.describe Table, type: :model do
  describe "Validation on Name Field" do

    context "when name field is nil" do
       let(:table) {build(:table,name:nil)}
        before do
          table.validate
        end
        it "should return false" do
          expect(table.errors).to include(:name)
        end
    end
  
    context "when name field is empty" do
      let(:table) {build(:table,name:"")}
       before do
         table.validate
       end
       it "should return false" do
         expect(table.errors).to include(:name)
       end
    end

    context "when name length is greater than 10" do
      let(:table) {build(:table,name:"tabletabletable")}
       before do
         table.validate
       end
       it "should return false" do
         expect(table.errors).to include(:name)
       end
    end

    context "when name field is not empty" do
    let(:table) {build(:table,name:"table")}
        before do
        table.validate
        end
        it "should return true" do
        expect(table.errors).to_not include(:name)
        end
    end
    
  end

  describe "Validation on member field" do

    context "when member is nil" do
      let(:table){build(:table,member:nil)}
      before do
        table.validate
      end
      it "should return false" do
        expect(table.errors).to include(:member)
      end
    end

    context "when member is empty" do
      let(:table){build(:table,member:"")}
      before do
        table.validate
      end
      it "should return false" do
        expect(table.errors).to include(:member)
      end
    end

    context "when member is less than 0" do
      let(:table){build(:table,member:"-1")}
      before do
        table.validate
      end
      it "should return false" do
        expect(table.errors).to include(:member)
      end
    end

    context "when member is equal to 0" do
        let(:table){build(:table,member:"0")}
        before do
          table.validate
        end
        it "should return false" do
          expect(table.errors).to include(:member)
        end
      end

    context "when member contains other characters" do
      let(:table){build(:table,member:"9p")}
      before do
        table.validate
      end
      it "should return false" do
        expect(table.errors).to include(:member)
      end
    end

    context "when member is greater than 0" do
        let(:table){build(:table)}
        before do
          table.validate
        end
        it "should return true" do
          expect(table.errors).to_not include(:member)
        end
    end

  end

  describe "association" do

    context "belongs_to"  do
      let(:restaurant) {create(:restaurant)}
      let(:table) {build(:table , restaurant:restaurant)}
      it "return table is true" do
        expect(table.restaurant).to be_an_instance_of(Restaurant)
      end
    end
    
  end

end
