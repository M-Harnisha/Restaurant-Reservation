require 'rails_helper'

RSpec.describe Order, type: :model do

      describe "Validation on rate field" do

        context "when rate is nil" do
          let(:order){build(:order,rate:nil)}
          before do
            order.validate
          end
          it "should return false" do
            expect(order.errors).to include(:rate)
          end
        end
    
        context "when rate is empty" do
          let(:order){build(:order,rate:"")}
          before do
            order.validate
          end
          it "should return false" do
            expect(order.errors).to include(:rate)
          end
        end
    
        context "when rate is less than 0" do
          let(:order){build(:order,rate:"-1")}
          before do
            order.validate
          end
          it "should return false" do
            expect(order.errors).to include(:rate)
          end
        end
    
       
        context "when rate contains other characters" do
          let(:order){build(:order,rate:"9p")}
          before do
            order.validate
          end
          it "should return false" do
            expect(order.errors).to include(:rate)
          end
        end

        context "when rate is greater than 0" do
            let(:order){build(:order)}
            before do
              order.validate
            end
            it "should return true" do
              expect(order.errors).to_not include(:rate)
            end
        end

    end

    describe "association" do

        context "belongs_to"  do
          let(:reservation) {create(:reservation)}
          let(:order) {build(:order , reservation:reservation)}
          it "return order is true" do
            expect(order.reservation).to be_an_instance_of(Reservation)
          end
        end
        
      end
    
end
