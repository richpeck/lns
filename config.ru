## RubyGems ##
## Required for Ubuntu ##
require 'rubygems'
require 'base64'  # => Used for webhook verification
require 'openssl' # => Used for webhook verification

## ENV ##
## Allows us to define before the App directory ##
DOMAIN        = ENV.fetch('DOMAIN', 'lockn-stitch-crafted.myshopify.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG         = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
ENVIRONMENT   = ENV.fetch("RACK_ENV", "development")
SHARED_SECRET = ENV.fetch("SECRET", false)

## Sinatra ##
require_relative 'app/app'
run App
