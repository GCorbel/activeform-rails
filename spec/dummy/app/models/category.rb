class Category < ActiveRecord::Base
  has_many :users
end
