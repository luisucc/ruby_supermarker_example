RSpec.describe "" do

  context "with no rules" do

    let(:checkout){ Checkout.new }

    it "returns 0 when there are no items" do
      total = checkout.total
      expect(total).to be 0.0
    end

    it "returns the same price as when adding one item" do
      item = Item.new code: "SR1", name: "Strawberry", price: 5.00
      checkout.scan(item)
      total = checkout.total
      expect(total).to be 5.00
    end

    it "returns the same price as when adding two items" do
      item_one = Item.new code: "SR1", name: "Strawberry", price: 5.00
      item_two = Item.new code: "FR1", name: "Fruit tea", price: 3.11
      checkout.scan(item_one)
      checkout.scan(item_two)
      total = checkout.total
      expect(total).to be 8.11
    end     

  end

  context "with rules" do

    let(:pricing_rules) do
      [:rule1, :rule2]
    end
    let(:checkout){ Checkout.new(pricing_rules) }

    it "returns buy-one-get-one-free offers whit fruit tea" do
      sr = Item.new code: "SR1", name: "Strawberry", price: 5.00
      fr = Item.new code: "FR1", name: "Fruit tea", price: 3.11
      cf = Item.new code: "CF1", name: "Coffee", price: 11.23
      [fr, sr, fr, fr, cf].each do |item|
        checkout.scan(item)
      end
      total = checkout.total
      expect(total).to be 22.45
    end  

    it "returns buy-one-get-one-free offers adding two fruit tea" do
      fr = Item.new code: "FR1", name: "Fruit tea", price: 3.11
      [fr, fr].each do |item|
        checkout.scan(item)
      end
      total = checkout.total
      expect(total).to be 3.11
    end 

    it "returns for bulk purchases offers adding 3 or more strawberries" do
      sr = Item.new code: "SR1", name: "Strawberry", price: 5.00
      fr = Item.new code: "FR1", name: "Fruit tea", price: 3.11
      cf = Item.new code: "CF1", name: "Coffee", price: 11.23
      [sr, sr, fr, sr].each do |item|
        checkout.scan(item)
      end
      total = checkout.total
      expect(total).to be 16.61
    end  

    it "returns for the 4 fruit tea, paying only 2 of them (pay 1, get 2)" do
      sr = Item.new code: "SR1", name: "Strawberry", price: 5.00
      fr = Item.new code: "FR1", name: "Fruit tea", price: 3.11
      cf = Item.new code: "CF1", name: "Coffee", price: 11.23
      [fr, sr, fr, fr, cf, fr].each do |item|
        checkout.scan(item)
      end
      total = checkout.total
      expect(total).to be 22.45
    end  
  end
end
