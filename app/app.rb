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

PARAMS      = Customer.column_names.excluding(:id, :created_at, :updated_at)

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

    # => Shopify
    # => Allows us to connect to the Shopify API via the gem
    ShopifyAPI::Base.site = "https://#{ENV.fetch('SHOPIFY_API')}:#{ENV.fetch('SHOPIFY_SECRET')}@#{ENV.fetch('SHOPIFY_STORE')}.myshopify.com"
    ShopifyAPI::Base.api_version = ENV.fetch("SHOPIFY_API_VERSION", "2019-10")

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
  route :get, :post, '/?:customer_id?' do

    ##############################
    ##############################

    # => GET
    # => Get information about user
    if request.get?
      @customer = Customer.find_by(customer_id: params[:customer_id]) if params.try(:[], :customer_id)
    end

    ##############################
    ##############################

    # => POST
    # => Allows us to perform things with data
    if request.post?

      # => Required Params
      # => Ensures we're able to only accept inbound requests with certain parameters
      required_params :customer_id if request.accept.map{ |item| item.to_s }.include?("application/json") # => Only if JSON request

      # => POST = the user has sent data to the service
      # => Allows us to change/manage the @customer object
      @customer = Customer.create_with({
          customer_name:            params.try(:[], :customer_name),
          gender:                   params.try(:[], :gender),
          height:                   params.try(:[], :height),
          weight:                   params.try(:[], :weight),
          neck:                     params.try(:[], :neck),
          shoulder_width:           params.try(:[], :shoulder_width),
          sleeve_length:            params.try(:[], :sleeve_length),
          bicep_circumference:      params.try(:[], :bicep_circumference),
          wrist_circumference:      params.try(:[], :wrist_circumference),
          chest_bust_circumference: params.try(:[], :chest_bust_circumference),
          waist_circumference:      params.try(:[], :waist_circumference),
          lower_waist:              params.try(:[], :lower_waist),
          hips_seat:                params.try(:[], :hips_seat)
      }).find_or_create_by({customer_id: params[:customer_id]}) # => Doesn't cause error if not found (https://stackoverflow.com/a/9604617/1143732)

      # => Update
      # => This is called because the above may only "find" the @customer record - we may need to update it
      # => To update it, we need to add the various new values sent by the user
      # => Remember, the only parameter we need is the customer_id - so we don't know if the others are valid or not
      @customer.assign_attributes params.slice(PARAMS).compact! # => https://stackoverflow.com/a/7430444/1143732
      @customer.update if @customer.changed?

      # => Metafields
      # => This allows us to create metafields for the customer
      customer = ShopifyAPI::Customer.find @customer.customer_id

      # => Cycle Params
      # => Allows us to populate/update metafields based on what the user has added
      # => Just do everything as string for now
      params.slice(PARAMS).each do |k,v|
        customer.add_metafield ShopifyAPI::Metafield.new(namespace: "measurements", key: k, value: v, value_type: "string") if PARAMS.include? k
      end

    end

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
