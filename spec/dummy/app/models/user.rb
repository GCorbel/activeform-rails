class User < ActiveRecord::Base
  has_one :category
end
