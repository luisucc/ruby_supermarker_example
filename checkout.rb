class Checkout

  attr_accessor :items, :pricing_rules

  def initialize(pricing_rules = [])
    @items = []
    @pricing_rules = pricing_rules
  end

  def scan(item)
    @items << item
  end

  def total
    all_subtotals = 0
    all_touched_items = []

    pricing_rules.map do |rule|
      subtotal, touched_items = rule.call(items)
      all_subtotals += subtotal
      all_touched_items += touched_items
    end

    untouched_items = items - all_touched_items

    (all_subtotals + untouched_items.map(&:price).sum).round(2)
  end

end