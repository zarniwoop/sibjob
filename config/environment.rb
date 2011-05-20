if ENV['RAILS_ENV'] == 'production'  # don't bother on dev
  ENV['GEM_PATH'] = '/home/jabink/.gems' + ':/usr/lib/ruby/gems/1.8'
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sibjob::Application.initialize!