require 'rails_helper'

RSpec.describe Reservation, type: :model do

    describe "Validation on date Field" do

        context "when date field is nil" do
           let(:reservation) {build(:reservation,date:nil)}
            before do
              reservation.validate
            end
            it "should return false" do
              expect(reservation.errors).to include(:date)
            end
        end
      
        context "when date field is empty" do
          let(:reservation) {build(:reservation,date:"")}
           before do
             reservation.validate
           end
           it "should return false" do
             expect(reservation.errors).to include(:date)
           end
        end
    
          context "when date format is not correct" do
            let(:reservation) {build(:reservation,date:"abc")}
              before do
                reservation.validate
              end
              it "should return false" do
                expect(reservation.errors).to include(:date)
              end
          end

          context "when date is in past" do
            let(:reservation) {build(:reservation,date:"2003/05/10")}
              before do
                reservation.validate
              end
              it "should return false" do
                expect(reservation.errors).to include(:date)
              end
          end

          context "when date format is correct" do
            let(:reservation) {build(:reservation)}
              before do
                reservation.validate
              end
              it "should return true" do
                expect(reservation.errors).to_not include(:date)
              end
          end
      end


      describe "association" do

        context "belongs_to"  do
          let(:restaurant) {create(:restaurant)}
          let(:reservation) {build(:reservation , restaurant:restaurant)}
          it "return reservation is true" do
            expect(reservation.restaurant).to be_an_instance_of(Restaurant)
          end
        end

        context "belongs_to"  do
            let(:user) {create(:user)}
            let(:reservation) {build(:reservation , user:user)}
            it "return reservation is true" do
              expect(reservation.user).to be_an_instance_of(User)
            end
          end
        
      end
end
