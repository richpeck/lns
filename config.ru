
## ENV ##
if Gem::Specification.find_all_by_name('dotenv').any?
  require 'dotenv'
  Dotenv.load
end

## Sinatra ##
require_relative 'app/app'
App.run!
