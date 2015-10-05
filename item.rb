require "virtus"

class Item
  include Virtus.model

  attribute :code, String
  attribute :name, String
  attribute :price, Float
end