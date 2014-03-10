module ActiveForm::Form
  class MockModel
    def self.model_name
      ActiveModel::Name.new(self)
    end
  end
end
