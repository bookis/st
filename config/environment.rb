# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')
require File.join(File.dirname(__FILE__), 'savetogether.rb')

Rails::Initializer.run do |config|
  #resource_hacks required here to ensure routes like /:login_slug work
  config.plugins = [:engines, :community_engine, :white_list, :all]
  config.plugin_paths += ["#{RAILS_ROOT}/vendor/plugins/community_engine/engine_plugins"]

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "hpricot", :version => '0.8.1'
  config.gem "haml", :version => '2.0.9'
  config.gem "htmlentities", :version => '4.0.0'
  config.gem "money", :version => '2.1.3'
  config.gem "RedCloth", :version => '4.1.9'
  config.gem "activemerchant", :lib => "active_merchant", :version => "1.4.2"
  config.gem "populator", :version => "0.2.5"
  config.gem "faker", :version => "0.3.1"
  config.gem "ruport"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end# Include your application configuration below
require "#{RAILS_ROOT}/vendor/plugins/community_engine/engine_config/boot.rb"

APP_URL = AppConfig.app_url

unless ENV['RAILS_ENV'] == 'production'
  ActiveMerchant::Billing::Base.mode = :test
end
PAYPAL_ACCOUNT = AppConfig.paypal_account

error_email = AppConfig.exception_notification_email
ExceptionNotifier.exception_recipients = error_email

I18n.reload!
require "ruport"

# =============================================================================
require 'lib/message_logger'
logger = MessageLogger.new(RAILS_ENV, File.join( 'log/', RAILS_ENV + ".log"))
ActiveRecord::Base.logger = logger
ActionController::Base.logger = logger
# =============================================================================
