require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  
    describe "Validation on Name Field" do

        context "when name field is nil" do
           let(:menu_item) {build(:menu_item,name:nil)}
            before do
              menu_item.validate
            end
            it "should return false" do
              expect(menu_item.errors).to include(:name)
            end
        end
      
        context "when name field is empty" do
          let(:menu_item) {build(:menu_item,name:"")}
           before do
             menu_item.validate
           end
           it "should return false" do
             expect(menu_item.errors).to include(:name)
           end
        end
    
        context "when name field is less than 3" do
          let(:menu_item) {build(:menu_item,name:"hr")}
            before do
              menu_item.validate
            end
            it "should return false" do
              expect(menu_item.errors).to include(:name)
            end
        end
    
        context "when name field is greater than 15" do
        let(:menu_item) {build(:menu_item,name:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
            before do
            menu_item.validate
            end
            it "should return false" do
            expect(menu_item.errors).to include(:name)
            end
        end

        context "when name field is between 3 and  15" do
        let(:menu_item) {build(:menu_item)}
            before do
            menu_item.validate
            end
            it "should return true" do
            expect(menu_item.errors).to_not include(:name)
            end
        end
        
    end

    describe "Validation on quantity field" do

        context "when quantity is nil" do
          let(:menu_item){build(:menu_item,quantity:nil)}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:quantity)
          end
        end
    
        context "when quantity is empty" do
          let(:menu_item){build(:menu_item,quantity:"")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:quantity)
          end
        end
    
        context "when quantity is less than 0" do
          let(:menu_item){build(:menu_item,quantity:"-1")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:quantity)
          end
        end
    
        context "when quantity is equal to 0" do
            let(:menu_item){build(:menu_item,quantity:"0")}
            before do
              menu_item.validate
            end
            it "should return false" do
              expect(menu_item.errors).to include(:quantity)
            end
          end
    
        context "when quantity contains other characters" do
          let(:menu_item){build(:menu_item,quantity:"9p")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:quantity)
          end
        end

        context "when quantity is greater than 0" do
            let(:menu_item){build(:menu_item)}
            before do
              menu_item.validate
            end
            it "should return true" do
              expect(menu_item.errors).to_not include(:quantity)
            end
        end

    end

    describe "Validation on rate field" do

        context "when rate is nil" do
          let(:menu_item){build(:menu_item,rate:nil)}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:rate)
          end
        end
    
        context "when rate is empty" do
          let(:menu_item){build(:menu_item,rate:"")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:rate)
          end
        end
    
        context "when rate is less than 0" do
          let(:menu_item){build(:menu_item,rate:"-1")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:rate)
          end
        end
    
        context "when rate is equal to 0" do
            let(:menu_item){build(:menu_item,rate:"0")}
            before do
              menu_item.validate
            end
            it "should return false" do
              expect(menu_item.errors).to include(:rate)
            end
          end
    
        context "when rate contains other characters" do
          let(:menu_item){build(:menu_item,rate:"9p")}
          before do
            menu_item.validate
          end
          it "should return false" do
            expect(menu_item.errors).to include(:rate)
          end
        end

        context "when rate is greater than 0" do
            let(:menu_item){build(:menu_item)}
            before do
              menu_item.validate
            end
            it "should return true" do
              expect(menu_item.errors).to_not include(:rate)
            end
        end

    end

    describe "association" do

        context "belongs_to"  do
          let(:restaurant) {create(:restaurant)}
          let(:menu_item) {build(:menu_item , restaurant:restaurant)}
          it "return menu_item is true" do
            expect(menu_item.restaurant).to be_an_instance_of(Restaurant)
          end
        end
        
      end
    
end
