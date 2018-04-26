class StripeWebhookService


  # What matters
  #  We have a card on file when we need it
  #  We handle payment failure
  #  We keep user.subscription_state in sync with Stripe
  #     Set trialing when sub with trial
  #     Set a
  #  We handle cancellations
  #  We handle plan upgrades and downgrades
  #
  #

  # relevant webhooks
  #  customer.subscription.trial_will_end  make sure they have a card!
  #  invoice.payment_succeeded   subscription state becomes ??
  #  invoice.payment_failed      subscription state becomes 'past_due'
  #
  #

  def initialize(event)
    @event = event
    case @event.type
      when 'customer.subscription.trial_will_end'
        request_card
      when 'invoice.payment_succeeded'
        handle_paid_invoice
      when 'invoice.payment_failed'
        handle_unpaid_invoice
      else
        nil
    end
  end

  private

    # customer.subscription.trial_will_end
    def request_card
      # If no card on file, ask them to add one
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user and user.last4.nil?
        StripeMailer.card_request(user).deliver
      end
    end

    # invoice.payment_succeeded
    def handle_paid_invoice
      # thank customer
      # set user.subscription_state 'active'
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user
        user.update_attribute(:subscription_state, 'active')
        StripeMailer.subscription_payment_received(user).deliver
      end
    end

    # invoice.payment_failed
    def handle_unpaid_invoice
      # tell customer to fix/add card
      # set user.subscription_state 'past_due'
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user
        user.update_attribute(:subscription_state, 'past_due')
        StripeMailer.subscription_payment_failed(user).deliver
      end
    end

end