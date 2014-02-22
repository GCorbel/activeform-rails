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
    assign_from_hash(attributes)
  end

  def fill_attributes(params)
    assign_from_hash(params)
  end

  def save
    valid?.tap do
      each_models(&:save)
    end
  end

  def save!
    ActiveRecord::Base.transaction do
      each_models(&:save!)
    end
  end

  def main_model
    send(self.class.main_model)
  end

  private

  def each_models
    self.class.models.each do |model_name|
      yield(send(model_name))
    end
  end

  def assign_from_hash(hash)
    hash.each { |key, value| send("#{key}=", value) }
  end
end
