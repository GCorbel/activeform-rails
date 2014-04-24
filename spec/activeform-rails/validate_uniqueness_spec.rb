require 'spec_helper'

describe ActiveForm::ValidateUniqueness do
  class ValidateUniquenessForm
    include ActiveForm::Form
    include ActiveForm::ValidateUniqueness
    properties :name, :firstname, on: :user
    validates_uniqueness_of :name, :user, allow_nil: true
    validates_uniqueness_of :firstname, :user, allow_nil: true
  end

  context "when there is no user" do
    it "is valid" do
      user = User.new
      form = ValidateUniquenessForm.new(user: user)
      expect(form).to be_valid
    end
  end

  context "when there is user with the same email" do
    context "when the user has an available name" do
      it "is valid" do
        user = User.create(name: 'name')
        form = ValidateUniquenessForm.new(user: user)
        expect(form).to be_valid
      end
    end

    context "when the user has unavailable name" do
      it "is not valid" do
        User.create(name: 'name')
        user = User.new(name: 'name')
        form = ValidateUniquenessForm.new(user: user)
        expect(form).to_not be_valid
      end

      it "assign an error to the name" do
        User.create(name: 'name')
        user = User.new(name: 'name')
        form = ValidateUniquenessForm.new(user: user)
        form.valid?
        expect(form.errors[:name]).to_not be_empty
      end
    end
  end
end
