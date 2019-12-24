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

## Orders ##
## Allows us to populate orders received from Shopify ##
class CreateCustomers < ActiveRecord::Migration::Current

  ###########################################
  ###########################################

  # => Decs
  @@table = Customer.table_name

  ###########################################
  ###########################################

  ## Up ##
  def up
    create_table @@table do |t|

      # => Attributes
      # => These may be added to later
      t.string     :customer_id
      t.string     :customer_name
      t.integer    :gender
      t.string     :height
      t.integer    :weight
      t.string     :neck
      t.string     :shoulder_width
      t.string     :sleeve_length
      t.string     :bicep_circumference
      t.string     :wrist_circumference
      t.string     :chest_bust_circumference
      t.string     :waist_circumference
      t.string     :lower_waist
      t.string     :hips_seat

      # => Timestamps
      t.timestamps

      # => Index
      # => Allows us to save only valid records
      t.index :customer_id, unique: true, name: 'customer_id_unique_index'

    end
  end

  ###########################################
  ###########################################

  ## Down ##
  def down
    drop_table @@table, if_exists: true
  end

  ###########################################
  ###########################################

end

############################################################
############################################################
