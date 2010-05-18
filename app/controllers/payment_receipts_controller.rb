class PaymentReceiptsController < ApplicationController
  before_filter :require_user
  
  def show
    @payments = current_user.payments.paid
  end
end
