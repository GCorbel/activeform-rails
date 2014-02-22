class UserForm
  include ActiveForm::Form
  include ActiveForm::ValidateUniqueness

  properties :name, on: :user
  properties :title, on: :category

  validates_uniqueness_of :name, :user

  self.main_model = :user

  validates :name, presence: true
end
