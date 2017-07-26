require 'csv'
class Customer < ApplicationRecord
  has_many :orders
  def sim_pearson(customer2)
    si={}
    cs2_orders = []
    customer2.orders.each do |order|
      cs2_orders.push(order.model)
    end
    self.orders.each do |order|
      if cs2_orders.include?(order.model)
        si[order.model]=1
      end
    end

    n = si.length

    if n == 0; return 0 end

    sum1 = 0
    sum2 = 0
    sum1Sq = 0
    sum2Sq = 0
    pSum = 0
    si.each do |model|
      c1_price = self.orders.find_by_model(model).order_price
      c2_price = customer2.orders.find_by_model(model).order_price
      sum1 += c1_price
      sum2 += c2_price
      sum1Sq += c1_price ** 2
      sum2Sq += c2_price ** 2
      pSum += (c1_price * c2_price)
    end

    num = pSum-(sum1*sum2/n)
    den = Math.sqrt((sum1Sq-(sum1 ** 2)/n)*(sum2Sq-(sum2 ** 2)/n))
    if den == 0; return 0 end

    r = num/den
  end

  def compare
    comps = {}
    comps_returned = {}
    Customer.all.each do |customer|
      if customer.id != self.id
        sp = self.sim_pearson(customer)
        comps[customer.name] = sp
      end
    end
    comps.sort_by {|customer, value| value}.reverse.each do |arr|
      comps_returned[arr[0]] = arr[1]
    end
    comps_returned
  end

  def missing_items(customer2)
    c1_orders = []
    mi = {}
    mi_returned = {}
    c2_total_sales = customer2.get_total_orders
    self.orders.each do |order|
      c1_orders.push(order.model)
    end

    customer2.orders.each do |order|
      if !c1_orders.include?(order.model)
        mi[order.model] = (customer2.orders.find_by_model(order.model).order_price / c2_total_sales)
      end
    end
    mi.sort_by {|model, value| value}.reverse.each do |arr|
      mi_returned[arr[0]] = arr[1]
    end
    mi_returned
  end

  def self.get_customers
    csv_text = File.read("customers.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Customer.create(name: row['customer_name'])
    end
  end

  def get_total_orders
    sum = 0
    self.orders.each do |order|
      sum += order.order_price
    end
    sum
  end
end
