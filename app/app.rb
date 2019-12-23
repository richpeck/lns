##########################################################################
##########################################################################
##   _      _   _  _____        _   ___   _______                       ##
##  | |    | \ | |/  ___|      | \ | \ \ / /  __ \                      ##
##  | |    |  \| |\ `--. ______|  \| |\ V /| /  \/  ___ ___  _ __ ___   ##
##  | |    | . ` | `--. \______| . ` | \ / | |     / __/ _ \| '_ ` _ \  ##
##  | |____| |\  |/\__/ /      | |\  | | | | \__/\| (_| (_) | | | | | | ##
##  \_____/\_| \_/\____/       \_| \_/ \_/  \____(_)___\___/|_| |_| |_| ##
##                                                                      ##
##########################################################################
##########################################################################
##                     Main Sinatra app.rb file                         ##
##        Allows us to define, manage and serve various routes          ##
##########################################################################
##########################################################################

## Definitions ##
## Constants defined here ##
DOMAIN      = ENV.fetch('DOMAIN', 'lns-nyc.myshopify.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG       = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
ENVIRONMENT = ENV.fetch("RACK_ENV", "development") ## allows us to call environemnt

##########################################################
##########################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENVIRONMENT

##########################################################
##########################################################

# => Models
# => This allows us to load all the models (which are not loaded by default)
require_all 'app'

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

  ##########################################################
  ##########################################################
  ##            _____              __ _                   ##
  ##           /  __ \            / _(_)                  ##
  ##           | /  \/ ___  _ __ | |_ _  __ _             ##
  ##           | |    / _ \| '_ \|  _| |/ _` |            ##
  ##           | \__/\ (_) | | | | | | | (_| |            ##
  ##            \____/\___/|_| |_|_| |_|\__, |            ##
  ##                                     __/ |            ##
  ##                                    |___/             ##
  ##########################################################
  ##########################################################

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Cors                # => Protects from unauthorized domain activity
    register Padrino::Helpers             # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith         # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute          # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace           # => Namespace (http://sinatrarb.com/contrib/namespace.html)

    # => Helpers
    # => Allows us to manage the system at its core
    helpers Sinatra::RequiredParams # => Required Parameters (ensures we have certain params for different routes)

  ##########################################################
  ##########################################################

    # => Development
    # => Ensures we're only loading in development environment
    configure :development do
      register Sinatra::Reloader  # => http://sinatrarb.com/contrib/reloader
    end

  ##########################################################
  ##########################################################

  # => General
  # => Allows us to determine various specifications inside the app
  set :haml, { layout: :'layouts/application' } # https://stackoverflow.com/a/18303130/1143732
  set :views, Proc.new { File.join(root, "views") } # required to get views working (defaulted to ./views)
  set :public_folder, File.join(root, "..", "public") # Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory

  # => Required for CSRF
  # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
  set :protect_from_csrf, true

  ##########################################################
  ##########################################################

  # => Asset Pipeline
  # => Allows us to precompile assets as you would in Rails
  # => https://github.com/kalasjocke/sinatra-asset-pipeline#customization
  set :assets_prefix, '/dist' # => Needed to access assets in frontend
  set :assets_public_path, File.join(public_folder, assets_prefix.strip) # => Needed to tell Sprockets where to put assets
  set :assets_css_compressor, :sass # => Required to minimize SASS
  set :assets_js_compressor, :uglifier # => Required to minimize JS
  set :assets_precompile, %w[javascripts/app.js stylesheets/app.sass *.png *.jpg *.gif *.svg] # *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2
  set :precompiled_environments, %i(development test staging production) # => Only precompile in staging & production

  # => Register
  # => Needs to be below definitions
  register Sinatra::AssetPipeline

  ##########################################################
  ##########################################################

  # => Sprockets
  # => This is for the layout (calling sprockets helpers etc)
  # => https://github.com/petebrowne/sprockets-helpers#setup
  configure do

    # RailsAssets
    # Required to get Rails Assets gems working with Sprockets/Sinatra
    # https://github.com/rails-assets/rails-assets-sinatra#applicationrb
    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end

    # Paths
    %w(stylesheets javascripts images).each do |folder|
      sprockets.append_path File.join(root, 'assets', folder)
      sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
    end

  end

  ##########################################################
  ##########################################################

  ## CORS ##
  ## Only allow requests from domain ##
  set :allow_origin,   URI::HTTPS.build(host: DOMAIN).to_s
  set :allow_methods,  "GET,POST,PUT,DELETE"
  set :allow_headers,  "accept,content-type,if-modified-since"
  set :expose_headers, "location,link"

  ##########################################################
  ##########################################################
  ##                   ___                                ##
  ##                  / _ \                               ##
  ##                 / /_\ \_ __  _ __                    ##
  ##                 |  _  | '_ \| '_ \                   ##
  ##                 | | | | |_) | |_) |                  ##
  ##                 \_| |_/ .__/| .__/                   ##
  ##                       | |   | |                      ##
  ##                       |_|   |_|                      ##
  ##########################################################
  ##########################################################

  # => Customer
  # => Gives us ability to manage customer information
  route :get, :post, '/:customer_id' do

    # => Required Params
    # => Ensures we're able to only accept inbound requests with certain parameters
    required_params :customer_id if request.accept.map{ |item| item.to_s }.include?("application/json") # => Only if JSON request

    # => Data
    # => Populate data for view/JSON response
    @customer  = Customer.find params[:customer_id]
    @customers = Customer.all

    # => Response
    # => This can be HTML or JSON
    respond_to do |format|
      format.js   { json @customer.to_json }
      format.html { haml :index }
    end

  end ## get

end ## app.rb

##########################################################
##########################################################
