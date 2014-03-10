require 'active_record'
require 'activeform-rails'
require 'database_cleaner'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{Dir.pwd}/database.sqlite3"
)

class User < ActiveRecord::Base
  has_many :categories
end

class Category < ActiveRecord::Base
  belongs_to :user
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# hide deprecation warnings, see http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
I18n.config.enforce_available_locales = true

