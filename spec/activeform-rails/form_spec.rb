require 'spec_helper'

describe ActiveForm do
  context 'backed by models' do
    class Form
      include ActiveForm::Form
      properties :name, on: :user
      properties :title, on: :category

      attr_accessor :user, :category

      self.main_model = :user
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
          Form.main_class = Category
          expect(Form.main_class).to eq Category
        end
      end

      context "when there is only a main model specified" do
        it "build the main class from the main model" do
          Form.main_model = :category
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
      context "when the form is valid" do
        context "when no block is given" do
          it "save all models" do
            user = User.new
            category = Category.new
            form = Form.new(user: user, category: category)
            expect(user).to receive(:save)
            expect(category).to receive(:save)
            form.save
          end

          it "return true" do
            form = Form.new(user: User.new, category: Category.new)
            allow(form).to receive(:valid?).and_return(true)
            expect(form.save).to eq true
          end
        end

        context "when a block is given" do
          it "use the block" do
            user = User.new
            form = Form.new(user: user, category: Category.new)
            allow(form).to receive(:valid?).and_return(true)
            expect(user).to receive(:process)
            form.save { |f| f.user.process }
          end
        end
      end

      context "when the form is invalid" do
        it "return false" do
          form = Form.new(user: User.new, category: Category.new)
          allow(form).to receive(:valid?).and_return(false)
          expect(form.save).to eq false
        end
      end
    end

    describe "#save!" do
      context "when no block is given" do
        it "save all models" do
          user = User.new
          category = Category.new
          form = Form.new(user: user, category: category)
          expect(user).to receive(:save!)
          expect(category).to receive(:save!)
          form.save!
        end

        it "is surrounded by a transaction" do
          expect(ActiveRecord::Base).to receive(:transaction).at_least(:once).
            and_yield
          form = Form.new(user: User.new, category: Category.new)
          form.save!
        end
      end

      context "when a block is given" do
        it "use the block" do
          user = User.new
          form = Form.new(user: user, category: Category.new)
          expect(user).to receive(:process)
          form.save! { |f| f.user.process }
        end
      end
    end

    describe "#main_model" do
      it "give the main model" do
        Form.main_model = :category
        category = Category.new
        form = Form.new(user: User.new, category: category)
        expect(form.main_model).to eq category
      end
    end

    describe "#persisted?" do
      it "should be false when not saved" do
        form = Form.new(user: User.new, category: Category.new)
        expect(form.persisted?).to eq false
      end

      it "should be true when not saved" do
        form = Form.new(user: User.new, category: Category.new)
        form.save!
        expect(form.persisted?).to eq true
      end
    end

    describe "#new_record?" do
      it "should be true when not saved" do
        form = Form.new(user: User.new, category: Category.new)
        expect(form.new_record?).to eq true
      end

      it "should be false when not saved" do
        form = Form.new(user: User.new, category: Category.new)
        form.save!
        expect(form.new_record?).to eq false
      end
    end

    describe "class method #alias_method" do
      class AliasForm
        include ActiveForm::Form
        properties :name, on: :user
        alias_property :full_name, :name
        self.main_model = :user
      end

      subject do
        user = User.new(name: 'John')
        AliasForm.new(user: user)
      end

      it "should allow alias name to be used for read operations" do
        expect(subject.full_name).to eq 'John'
      end

      it "should allow alias name to be used for write operations" do
        subject.full_name = 'Mike'
        expect(subject.full_name).to eq 'Mike'
      end
    end
  end

  context 'without any underlying models' do
    class FormNoModels
      include ActiveForm::Form
      properties :name, :title
    end

    it 'it should allow initialization without any arg' do
      form = FormNoModels.new
      expect(form.name).to eq nil
      expect(form.title).to eq nil
    end

    it 'it should args to be set on initialize' do
      form = FormNoModels.new(name: 'John', title: 'CEO')
      expect(form.name).to eq 'John'
      expect(form.title).to eq 'CEO'
    end

    it 'should raise an exception on save' do
      expect { FormNoModels.new.save }.to raise_exception(ActiveForm::CannotBePersisted)
    end

    it 'should raise an exception on save!' do
      expect { FormNoModels.new.save! }.to raise_exception(ActiveForm::CannotBePersisted)
    end

    it 'should delegate class method #model_name' do
      expect(FormNoModels.model_name.to_s).to eq 'FormNoModels'
    end

    it 'should delegate #to_key' do
      expect(FormNoModels.new.to_key).to eq nil
    end

    it 'should delegate #to_param' do
      expect(FormNoModels.new.to_param).to eq nil
    end

    it 'should delegate #id' do
      expect(FormNoModels.new.id).to eq nil
    end

    it 'should always return false to #persisted?' do
      expect(FormNoModels.new.persisted?).to be_false
    end
  end
end
