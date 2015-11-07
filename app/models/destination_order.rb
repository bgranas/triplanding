# A destination order object represents the order of destinations within a trip.
# The order of destinations will be determined by the order_authority column
# A smaller order_authority will indicate a destination is earlier in a given trip
# Order_authority will be set in multiples of 100, to make inserting easier
# See http://stackoverflow.com/questions/65205/linked-list-in-sql for details of algorithm

class DestinationOrder < ActiveRecord::Base
  belongs_to :trip
  belongs_to :destination
end
