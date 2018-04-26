class StripeWebhookService


  # We have a card on file when we need it
  # We handle payment failure
  # We keep user.subscription_state in sync with Stripe
  #   Set trialing when sub with trial
  #   Set active once paid
  #   Set overdue if payment failed (watch for eventual success)

  #  Cancellations
  #  Plan upgrades and downgrades

  # [trialing active past_due canceled unpaid error]

  # relevant webhooks
  #  customer.subscription.trial_will_end  make sure they have a card!
  #  invoice.created              payment comes in one hour
  #  invoice.payment_succeeded    subscription state becomes 'active'
  #  invoice.payment_failed       subscription state becomes 'past_due'

  def initialize(event)
    @event = event
    case @event.type
      when 'customer.subscription.created'
        happy_dance
      when 'customer.subscription.trial_will_end'
        request_card
      when 'invoice.created'
        happy_dance
      when 'invoice.payment_succeeded'
        handle_paid_invoice
      when 'invoice.payment_failed'
        handle_unpaid_invoice
      when 'customer.subscription.deleted'
        done_attempting_payment
      else
        nil
    end
  end

  private

    # customer.subscription.created
    # invoice.created
    def happy_dance
      # we're in a good mood
    end

    # customer.subscription.trial_will_end
    def request_card
      # If no card on file, ask them to add one
      # user = User.find 5
      # StripeMailer.card_request(user).deliver
      # user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user and user.last4.nil?
        StripeMailer.card_request(user).deliver
        # tell JK
        Notifier.card_requested(user).deliver
      end
    end

    # invoice.payment_succeeded
    def handle_paid_invoice
      # thank customer
      # set user.subscription_state 'active'
      # user = User.find 5
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user
        user.update_attribute(:subscription_state, 'active')
        StripeMailer.subscription_payment_received(user).deliver
        # tell JK
        Notifier.payment_succeeded(user).deliver
      end
    end

    # invoice.payment_failed
    def handle_unpaid_invoice
      # tell customer to fix/add card
      # set user.subscription_state 'past_due'
      # retry for a while
      # user = User.find 5
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user
        user.update_attribute(:subscription_state, 'past_due')
        StripeMailer.subscription_payment_failed(user).deliver
        # tell JK
        Notifier.payment_failed(user).deliver
      end
    end

    # customer.subscription.deleted
    def done_attempting_payment
      # Stripe retry attempts have ended
      #   They automatically cancelled the subscription
      #     TODO make sure automatic by event.request == 'null'
      # downgrade to associate plan
      user = User.find_by_stripe_customer_id(@event.data.object.id)
      if user
        # TODO downgrade their plan
        user.update_attribute(:subscription_state, 'canceled')
        # tell JK
        Notifier.cancel_for_non_payment(user).deliver
      end
    end

end