require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Validation on preference Field" do

    context "when preference field is nil" do
       let(:user) {build(:user,preference:nil)}
        before do
          user.validate
        end
        it "should return false" do
          expect(user.errors).to include(:preference)
        end
    end

    context "when preference field is empty" do
      let(:user) {build(:user,preference:"")}
       before do
         user.validate
       end
       it "should return false" do
         expect(user.errors).to include(:preference)
       end
    end

    context "when preference[type] is nil" do
      let(:user) {build(:user,preference: { type: [] })}
       before do
         user.validate
       end
       it "should return false" do
         expect(user.errors).to include(:preference)
       end
    end

    context "when preference[type] is empty" do
      let(:user) {build(:user,preference: { type: [""] })}
       before do
         user.validate
       end
       it "should return false" do
         expect(user.errors).to include(:preference)
       end
    end

    context "when preference[type] has wrong values" do
      let(:user) {build(:user,preference: { type: ['chinese'] })}
       before do
         user.validate
       end
       it "should return false" do
         expect(user.errors).to include(:preference)
       end
    end

    context "when preference[type] has correct values" do
      let(:user) {build(:user,preference: { type: ['vegetarian'] })}
       before do
         user.validate
       end
       it "should return true" do
         expect(user.errors).to_not include(:preference)
       end
    end

  end
end
