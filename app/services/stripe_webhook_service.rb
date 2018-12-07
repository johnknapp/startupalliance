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

    # TODO keep constants updated

    case @event.type
      when 'customer.subscription.created'
        happy_dance
      when 'customer.subscription.trial_will_end'
        request_card
      when 'customer.subscription.updated'
        update_subscription
      when 'invoice.upcoming'
        notify_upcoming_invoice
      when 'invoice.created'
        happy_dance
      when 'invoice.payment_succeeded'
        handle_paid_invoice
      when 'invoice.payment_failed'
        handle_unpaid_invoice
      when 'customer.subscription.deleted'
        done_attempting_payment
      when 'customer.subscription.updated'
        happy_dance
      else
        nil
    end
  end

  private

    # customer.subscription.created
    # invoice.created
    # customer.subscription.updated
    def happy_dance
      # we're in a good mood
      # spread the word
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user
        Notifier.happy_dance(user,@event).deliver
      end
    end

    # customer.subscription.trial_will_end three days from onw
    def request_card
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user
        # make them active state
        if user.subscription_state == 'trialing'
          user.update_attribute(:subscription_state, 'active')
        end
        # ask for a card if they need to
        if user.last4.nil? and user.next_invoice.amount_due != 0
          StripeMailer.card_request(user).deliver
          Notifier.card_requested(user).deliver
        end
      end
    end

    # customer.subscription.updated
    # Catch dashboard changes to the subscription
    #   add or remove coupons
    #   TODO change plans . . . or reset if plan is not changing?
    # Catch subscription state changes (trialing to active)
    def update_subscription
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user
        user.update_attribute(:subscription_state, @event['data']['object']['status'])
        if Rails.env.production?
          GibbonService.add_update(user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
        end
      end
      # user subscribed_at subscription_state stripe_coupon_code
      # registrations_controller#change_subscription handles
      # user.update(plan_id: plan.id, subscription_state: sub.status, stripe_coupon_code: stripe_coupon_code)
    end

    # invoice.upcoming three days from now
    def notify_upcoming_invoice
      # ask for a card if next invoice amount is non-zero
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user.next_invoice.amount_due != 0
        # ask for a card if they need to
        if user.last4.nil? and user.next_invoice.amount_due != 0
          StripeMailer.card_request(user).deliver
          Notifier.card_requested(user).deliver
        end
      end
    end

    # invoice.payment_succeeded
    def handle_paid_invoice
      # thank customer
      # set user.subscription_state 'active'
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user and @event['data']['object']['amount_due'] != 0
        user.update_attribute(:subscription_state, 'active')
        StripeMailer.subscription_payment_received(user).deliver
        Notifier.payment_succeeded(user).deliver
      end
    end

    # invoice.payment_failed
    def handle_unpaid_invoice
      # tell customer to fix/add card
      # set user.subscription_state 'past_due'
      # retry for a while
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user and @event['data']['object']['amount_due'] != 0
        user.update_attribute(:subscription_state, 'past_due')
        StripeMailer.subscription_payment_failed(user).deliver
        Notifier.payment_failed(user).deliver
      end
    end

    # customer.subscription.deleted
    def done_attempting_payment
      # Stripe retry attempts have ended and they automatically cancelled the subscription
      # we will migrate to free plan
      user = User.find_by_stripe_customer_id(@event['data']['object']['customer'])
      if user
        plan = Plan.find_by_name('intro_alliance_year')
        user.subscribe_to_stripe(plan) # they were cancelled so it's a new subscription
        StripeMailer.migrated_to_associate(user).deliver
        Notifier.cancel_for_non_payment(user).deliver
      end
    end

end