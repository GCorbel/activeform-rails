module ActiveForm
  class CannotBePersisted < Exception; end
end

require 'active_support/core_ext/module/delegation'
require 'active_record'
require 'activeform-rails/form'
require 'activeform-rails/validate_uniqueness'
