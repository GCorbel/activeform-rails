# MockModel allows the ActiveForm::Form object to delegate methods to
# this object with expected results
#
# - #model_name is used by Form helpers & Rails frequently to define the form namespace
# - #to_key, #to_param, #id should aways return nil as the Form cannot be persisted unless backed by ActiveModel
# - #persisted? should aways return false as the Form cannot be persisted unless backed by ActiveModel
#
module ActiveForm::Form
  class MockModel
    attr_reader :to_key, :to_param, :id

    def initialize(base_klass)
      @base_class = base_klass
    end

    def model_name
      ActiveModel::Name.new(@base_class)
    end

    def persisted?
      false
    end
  end
end
