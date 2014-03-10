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

    def properties(*attributes, prefix: false, on: nil)
      if on.nil?
        attr_accessor *attributes
      else
        assign_delegators(attributes, on, prefix)
        add_model_on_list(on)
        add_accessor(on)
      end
    end

    def i18n_scope
      :activerecord
    end

    def models
      @models ||= []
    end

    def main_model
      @main_model ||= MockModel.new(self)
    end

    def main_class
      @main_class ||= if main_model.kind_of?(Symbol)
        main_model.to_s.camelize.constantize
      else
        @main_model
      end
    end

    def alias_property(new_method, old_method)
      alias_method new_method.to_sym, old_method.to_sym
      alias_method "#{new_method}=".to_sym, "#{old_method}=".to_sym
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

  def initialize(attributes = {})
    assign_from_hash(attributes)
  end

  def fill_attributes(params)
    assign_from_hash(params)
  end

  def save(&block)
    ensure_persistable
    valid?.tap do
      call_action_or_block(:save, &block)
    end
  end

  def save!(&block)
    ensure_persistable
    ActiveRecord::Base.transaction do
      call_action_or_block(:save!, &block)
    end
  end

  def main_model
    if self.class.main_model.kind_of?(Symbol)
      send(self.class.main_model)
    else
      self.class.main_model
    end
  end

  def new_record?
    !persisted?
  end

  private

  def ensure_persistable
    message = 'The Form object is not backed by models so cannot be saved'
    if self.class.models.empty?
      raise ActiveForm::CannotBePersisted.new(message)
    end
  end

  def each_models
    self.class.models.each do |model_name|
      yield(send(model_name))
    end
  end

  def assign_from_hash(hash)
    hash.each { |key, value| send("#{key}=", value) }
  end

  def call_action_or_block(action, &block)
    block_given? ? block.call(self) : each_models(&action)
  end
end
