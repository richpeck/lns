###########################################
###########################################
##   _____                 __ _ _        ##
##  |  __ \               / _(_) |       ##
##  | |  \/ ___ _ __ ___ | |_ _| | ___   ##
##  | | __ / _ \ '_ ` _ \|  _| | |/ _ \  ##
##  | |_\ \  __/ | | | | | | | | |  __/  ##
##  \_____/\___|_| |_| |_|_| |_|_|\___|  ##
##                                       ##
###########################################
###########################################

# => Sources
# => Multiple sources now deprecated (unless a block is provided -- see RailsAssets below)
source 'https://rubygems.org'

###########################################
###########################################

# => [RailsAssets]
# => Requires source block to ensure gems pulled from this directly
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery'     # => JQuery
  gem 'rails-assets-datatables' # => Datatables
end

###########################################
###########################################

# => Ruby
# => https://github.com/cantino/huginn/blob/master/Gemfile#L4
ruby [RUBY_VERSION, '2.6.5'].max

###########################################
###########################################

# => Sinatra
# => Not big enough for Rails
gem 'sinatra', '~> 2.0', '>= 2.0.7',                                               require: ['sinatra/base', 'sinatra/namespace', 'sinatra/json'] # => Not needed but allows us to call /namespace
gem 'sinatra-activerecord', '~> 2.0', '>= 2.0.14',                                 require: 'sinatra/activerecord'                                # => Integrates ActiveRecord into Sinatra apps (I changed for AR6+)
gem 'sinatra-asset-pipeline', '~> 2.2', github: 'richpeck/sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'                              # => Asset Pipeline (for CSS/JS) (I changed lib/asset-pipeline/task.rb#14 to use ::Sinatra:Manifest)
gem 'sinatra-contrib', '~> 2.0', '>= 2.0.7',                                       require: 'sinatra/contrib'                                     # => Allows us to add "contrib" library to Sinatra app (respond_with) -> http://sinatrarb.com/contrib/
gem 'sinatra-cors', '~> 1.1',                                                      require: 'sinatra/cors'                                        # => Protect app via CORS

# => Database
# => Allows us to determine exactly which db we're using
# => To get the staging/production environments recognized by Heroku, set the "BUNDLE_WITHOUT" env var as explained here: https://devcenter.heroku.com/articles/bundler#specifying-gems-and-groups
gem 'sqlite3', group: :development
gem 'pg',      group: :staging
gem 'mysql2',  group: :production

# => Server
# => Runs puma in development/staging/production
gem 'puma' # => web server

###########################################
###########################################

# => Environments
# => Allows us to load gems depending on the environment
group :development do
  gem 'irb'     # => Console
  gem 'dotenv'  # => ENV vars (local)
  gem 'foreman' # => Allows us to run the app in development/testing
  gem 'byebug'  # => Debug tool for Ruby
end

###########################################
###########################################

####################
#     Backend      #
####################

# => General
gem 'shopify_api', '~> 8.1'                 # => Shopify API wrapper (used for metafields)
gem 'rake'                                  # => Allows for Rake usage
gem 'rack-flash3', require: 'rack-flash'    # => Flash messages for Rack apps

# => Asset Management
gem 'uglifier', '~> 4.2'         # => Uglifier - Javascript minification (required to get minification working)
gem 'sass', '~> 3.7', '>= 3.7.4' # => SASS - converts SASS into CSS (required for minification)

# => Extra
# => Added to help us manage data structures in app
gem 'addressable', '~> 2.7'        # => Break down the various components of a domain
gem 'activerecord', '6.0.2'        # => Allows us to use AR 6.0.0.rc1+ as opposed to 5.2.x (will need to keep up to date)
gem 'require_all', '~> 3.0'        # => Require an entire directory and include in an app
gem 'padrino-helpers', '~> 0.14.4' # => Sinatra framework which adds a number of support classes -- we needed it for "number_to_currency" (https://github.com/padrino/padrino-framework/blob/02feacb6afa9bce20c1fb360df4dfd4057899cfc/padrino-helpers/lib/padrino-helpers/number_helpers.rb)

###########################################
###########################################

####################
#     Frontend     #
####################

# => General
gem 'haml', '~> 5.1', '>= 5.1.2'                  # => HAML
gem 'titleize', '~> 1.4', '>= 1.4.1'              # => Titleize (for order line items)
gem 'humanize', '~> 2.1', '>= 2.1.1'              # => Humanize (allows us to translate numbers to words)

###########################################
###########################################
