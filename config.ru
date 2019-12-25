## RubyGems ##
## Required for Ubuntu ##
require 'rubygems' # => Necessary for Ubuntu

require 'base64'  # => Used for webhook verification
require 'openssl' # => Used for webhook verification
require 'active_support/security_utils' # => Used for webhook verification

require 'active_support/core_ext/hash'  # => Used for hash.except (https://www.reddit.com/r/ruby/comments/5opjqp/most_efficient_way_to_remove_keyvalue_from_a_hash/dcl50bz?utm_source=share&utm_medium=web2x)

## ENV ##
## Allows us to define before the App directory ##
DOMAIN        = ENV.fetch('DOMAIN', 'lockn-stitch-crafted.myshopify.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG         = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
ENVIRONMENT   = ENV.fetch("RACK_ENV", "development")
SHARED_SECRET = ENV.fetch("SECRET", false)

## Sinatra ##
require_relative 'app/app'
run App
