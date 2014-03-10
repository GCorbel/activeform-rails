require 'spec_helper'

describe 'ActiveForm ActiveRecord validators' do
  context 'backed by models' do
    class ValidationForm
      include ActiveForm::Form
      properties :name, on: :user
      validates_presence_of :name
    end

    context "when name is empty" do
      it "is not valid" do
        user = User.new
        form = ValidationForm.new(user: user)
        expect(form).to_not be_valid
      end
    end

    context "when name is filled in" do
      it "is valid" do
        user = User.new
        user.name = 'John'
        form = ValidationForm.new(user: user)
        expect(form).to be_valid
      end
    end
  end

  context 'without any underlying models' do
    class ValidationFormNoModels
      include ActiveForm::Form
      properties :name
      validates_presence_of :name
    end

    context "when name is empty" do
      it "is not valid" do
        form = ValidationFormNoModels.new
        expect(form).to_not be_valid
      end
    end

    context "when name is filled in" do
      it "is valid" do
        form = ValidationFormNoModels.new(name: 'John')
        expect(form).to be_valid
      end
    end
  end
end
