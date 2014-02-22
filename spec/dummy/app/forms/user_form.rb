class UserForm
  include ActiveForm::Form
  include ActiveForm::ValidateUniqueness

  properties :name, :category_id, :category, on: :user

  validates_uniqueness_of :name, :user

  self.main_model = :user

  validates :name, presence: true
end
