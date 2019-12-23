##########################################################
##########################################################
##   _____           _                                  ##
##  /  __ \         | |                                 ##
##  | /  \/_   _ ___| |_ ___  _ __ ___   ___ _ __ ___   ##
##  | |   | | | / __| __/ _ \| '_ ` _ \ / _ \ '__/ __|  ##
##  | \__/\ |_| \__ \ || (_) | | | | | |  __/ |  \__ \  ##
##   \____/\__,_|___/\__\___/|_| |_| |_|\___|_|  |___/  ##
##                                                      ##
##########################################################
##########################################################
## Saves customer object for use with orders
## Better to do it this way (separate data) - pulled from shipping address
##########################################################
##########################################################

## Customer ##
## id | customer_id | customer_name | gender | height | weight | shoulder_width | sleeve_length | bicep_circumference | wrist_circumference | chest_bust_circumference | wasit_circumference | lower_waist | hips_seat | created_at | updated_at ##
class Customer < ActiveRecord::Base

  # => Enum
  enum gender: [:male, :female]

  # => Table
  self.table_name = "customer"

  # => Attr
  alias_attribute :name, :customer_name

end

##########################################################
##########################################################
