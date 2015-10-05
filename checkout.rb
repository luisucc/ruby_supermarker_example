class Checkout

  attr_accessor :items

  def initialize(pricing_rules = nil)
    @items = []
  end

  def scan(item)
    price = item.price
    @items << item
  end

  def total
    total = 0
    count_fr = 0
    count_sr = 0
    items.each do |item|
      price = item.price
      if item.code == "FR1"
        count_fr = 1 + count_fr
        if count_fr == 2
          count_fr = 0 
          price = 0
        end
      end
      if item.code == "SR1"
        count_sr = 1 + count_sr
        if count_sr > 2
          price = 4.50
          if count_sr == 3
            total = total - 1.00
          end
        end
      end
      total = price + total
    end
    total
  end

  def pay_one_get_one_free_rule(items)
  end

  def three_or_more_discount_rule(items)
  end

  def lol_rule(items)
  end

end