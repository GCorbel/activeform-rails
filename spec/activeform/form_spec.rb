require 'spec_helper'

describe ActiveForm do
  class Form
    include ActiveForm::Form
    properties :name, on: :user
    properties :title, on: :category
    main_model :user
    attr_accessor :user, :category
  end

  describe ".main_class" do
    it "reflect assoctions of the main model" do
      user = User.new
      category = Category.new
      user.categories = [category]
      expect(Form.reflect_on_association(:has_many)).to eq \
        User.reflect_on_association(:has_many)
    end

    context "when a main class is specified" do
      it "take the specified class" do
        Form.set_main_class(Category)
        expect(Form.main_class).to eq Category
      end
    end

    context "when there is only a main model specified" do
      it "build the main class from the main model" do
        Form.main_model(:category)
        expect(Form.main_class).to eq Category
      end
    end
  end

  describe "#fill_attributes" do
    it "assign variable to models" do
      user = User.new
      category = Category.new
      form = Form.new(user: user, category: category)
      form.fill_attributes(name: "Martin")
      expect(user.name).to eq "Martin"
    end
  end

  describe "#save" do
    it "save all models" do
      user = User.new
      category = Category.new
      form = Form.new(user: user, category: category)
      expect(user).to receive(:save)
      expect(category).to receive(:save)
      form.save
    end
  end
end
