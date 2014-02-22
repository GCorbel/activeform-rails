class CategoryForm
  include ActiveForm::Form

  properties :title, on: :category

  self.main_model = :category

  validates :title, presence: true

  attr_accessor :user_ids

  def fill_attributes(attributes)
    super(attributes)
  end

  def save
    super do
      category.save
      category.users = user_ids.delete_if(&:empty?).map do |user_id|
        User.find(user_id)
      end
    end
  end
end
