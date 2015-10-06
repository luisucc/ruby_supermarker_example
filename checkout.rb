class Checkout

  attr_accessor :items

  def initialize(pricing_rules = nil)
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    sub_total_frs, touched_items_frs = pay_one_get_one_free_rule(items)
    sub_total_srs, touched_items_srs = three_or_more_discount_rule(items)

    touched_items = (touched_items_srs + touched_items_frs).uniq
    untouched_items = items - touched_items
    untouched_items_sub_total = untouched_items.map(&:price).sum

    (sub_total_frs + sub_total_srs + untouched_items_sub_total).round(2)
    
  end

  def pay_one_get_one_free_rule(items)
    frs = items.select{|item| item.code == "FR1"}
    sub_total_frs = ((frs.length + 1)/2).floor * frs.first.price rescue 0
    [sub_total_frs, frs]
  end

  def three_or_more_discount_rule(items)
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