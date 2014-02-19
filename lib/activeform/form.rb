module ActiveForm::Form
  def self.included(base)
    base.class_eval do
      extend ActiveModel::Naming
      include ActiveModel::Conversion
      include ActiveModel::Validations
    end
    base.extend ClassMethods
  end


  module ClassMethods
    delegate :model_name, :reflect_on_association, to: :main_class
    attr_accessor :reflected_class, :main_model_name

    def properties(*attributes, prefix: false, on:)
      @attributes = attributes
      @prefix = prefix
      @model_name = on
      assign_delegators
      add_model_on_list
      add_accessor
    end

    def i18n_scope
      :activerecord
    end

    def models
      @models ||= []
    end

    def set_main_class(klass)
      @main_class = klass
    end

    def main_class
      @main_class ||= @main_model_name.to_s.camelize.constantize
    end

    def main_model(main_model_name)
      @main_model_name = main_model_name
    end

    private

    def add_model_on_list
      models << @model_name unless models.include?(@model_name)
    end

    def add_accessor
      attr_accessor @model_name
    end

    def assign_delegators
      @attributes.each do |attribute|
        delegate attribute, to: @model_name, prefix: @prefix
        delegate "#{attribute}=", to: @model_name, prefix: @prefix
      end
    end
  end

  delegate :to_key, :to_param, :id, :persisted?, to: :main_model

  def initialize(attributes)
    attributes.each {|name, model| send("#{name}=", model)}
  end

  def fill_attributes(params)
    params.each_pair { |key, value| send("#{key}=", value) }
  end

  def save
    self.class.models.each { |model| send(model).save }
  end

  def main_model
    send(self.class.main_model_name)
  end
end
