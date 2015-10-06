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
      subtotal, touched_items = method(rule).call(items)
      all_subtotals += subtotal
      all_touched_items += touched_items
    end

    untouched_items = items - all_touched_items

    (all_subtotals + untouched_items.map(&:price).sum).round(2)
  end

  def rule1(items)
    frs = items.select{|item| item.code == "FR1"}
    sub_total_frs = ((frs.length + 1)/2).floor * frs.first.price rescue 0
    [sub_total_frs, frs]
  end

  def rule2(items)
    srs = items.select{|item| item.code == "SR1"}
    if srs.length >= 3  
      sub_total_srs = 4.50 * srs.length
    else
      sub_total_srs = srs.map(&:price).reduce(:+) || 0
    end
    [sub_total_srs, srs]
  end

  def lol_rule(items)
  end

end