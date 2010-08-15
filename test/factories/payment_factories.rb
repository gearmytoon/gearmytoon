Factory.define(:considering_payment, :class => :payment) do |model|
  model.raw_data({"something" => "true", "recurringFrequency" => "1 month", "transactionAmount" => "USD 3", "subscriptionId" => "1234"})
  model.association :purchaser, :factory => :user
end

Factory.define(:paid_payment, :parent => :considering_payment) do |model|
  model.after_create do |payment|
    payment.pay!
  end
end

Factory.define(:one_time_paid_payment, :parent => :considering_payment) do |model|
  model.raw_data({"something" => "true", "transactionAmount" => "USD 1"})
  model.after_create do |payment|
    payment.pay!
  end
end

Factory.define(:failed_payment, :parent => :considering_payment) do |model|
  model.after_create do |payment|
    payment.fail!
  end
end
