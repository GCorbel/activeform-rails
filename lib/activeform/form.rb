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
    attr_accessor :main_class, :reflected_class, :main_model

    def properties(*attributes, prefix: false, on:)
      assign_delegators(attributes, on, prefix)
      add_model_on_list(on)
      add_accessor(on)
    end

    def i18n_scope
      :activerecord
    end

    def models
      @models ||= []
    end

    def main_class
      @main_class ||= @main_model.to_s.camelize.constantize
    end

    private

    def add_model_on_list(model_name)
      models << model_name unless models.include?(model_name)
    end

    def add_accessor(model_name)
      attr_accessor model_name
    end

    def assign_delegators(attributes, model_name, prefix)
      attributes.each do |attribute|
        delegate attribute, to: model_name, prefix: prefix
        delegate "#{attribute}=", to: model_name, prefix: prefix
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
