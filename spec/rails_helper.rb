# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'

# automatically require all helpers
# none of these should rely on order
Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

# checks for pending migration and applies them before tests are run.
# if you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!

  # use the built-in directory types
  config.infer_spec_type_from_file_location!

  # extend with custom spec types as type: <:custom_type>
  %w(observer worker).each do |type|
    config.define_derived_metadata(:file_path => Regexp.new("/spec/#{type.pluralize}/")) do |metadata|
      metadata[:type] = type.to_sym
    end
  end

  # use nested folders to create subtypes as subtype: <:subtype>
  # useful for namespaces
  %w(controller feature request).each do |type|
    %w(admin api developers gamers).each do |sub|
      config.define_derived_metadata(:file_path => Regexp.new("/spec/#{type.pluralize}/#{sub}/")) do |metadata|
        metadata[:subtype] = "#{sub}_#{type}".to_sym
      end
    end
  end

  # manually include all helpers that were wrapped in modules
  # these exist in files name spec/support/*_helper.rb
  # allows for selective inclusion and override based on other metadata
  config.include GlobalHelper

  config.include ControllerHelper, type: :controller
  config.include AdminControllerHelper, subtype: :admin_controller
  config.include DevelopersControllerHelper, subtype: :developers_controller

  config.include ModelHelper, type: :model

  config.include ObserverHelper, type: :observer

  config.include WorkerHelper, type: :worker
end
