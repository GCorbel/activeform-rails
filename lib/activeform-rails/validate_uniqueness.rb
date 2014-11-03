module ActiveForm
  module ValidateUniqueness
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def validates_uniqueness_of(attribute, model_name, options = {})
        validates_each attribute, options do |form, attr, value|
          @form = form
          @model = form.send(model_name)
          @klass = @model.class
          @hash = { attribute => value }
          add_error_message(attribute) if another_model?
        end
      end

      private

      def another_model?
        @model.persisted? ? another_model_without_itself : any_model?
      end

      def another_model_without_itself
        @klass.where(@hash).to_a.delete_if { |m| m.id == @model.id }.count >= 1
      end

      def any_model?
        @klass.exists?(@hash)
      end

      def error_message
        I18n.t('activerecord.errors.messages.exclusion')
      end

      def add_error_message(attribute)
        @form.errors.add(attribute, error_message)
      end
    end
  end
end
