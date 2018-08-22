class User < ApplicationRecord
  include Pid
  include CountryName

  acts_as_reader
  acts_as_voter

  # Specifically not destroying some of their stuff
  has_many  :company_users,                          dependent: :destroy
  has_many  :companies, through: :company_users          # Keeping their companies
  has_many  :alliance_users,                         dependent: :destroy
  has_many  :alliances, through: :alliance_users         # See registrations#destroy and admin user destroy
  has_many  :user_traits,                            dependent: :destroy
  has_many  :traits, through: :user_traits
  has_many  :user_skills,                            dependent: :destroy
  has_many  :skills, through: :user_skills
  has_many  :conversations                               # TODO I removed dependent: :destroy - add to destroy methods instead.
  has_many  :fasts                                       # See registrations#destroy and admin user destroy
  has_many  :okrs,          foreign_key: :owner_id       # See registrations#destroy and admin user destroy
  has_many  :pages,         foreign_key: :author_id      # See registrations#destroy and admin user destroy
  has_many  :discussions,   foreign_key: :author_id, dependent: :destroy
  has_many  :topics,        foreign_key: :author_id, dependent: :destroy
  has_many  :posts,         foreign_key: :author_id, dependent: :destroy
  has_many  :quarks,        foreign_key: :author_id, dependent: :destroy
  has_many  :replies,       foreign_key: :author_id, class_name: :Post, dependent: :destroy
  has_many  :messages

  # https://www.krautcomputing.com/blog/2015/01/13/recalculate-counter-cache-columns-in-rails/
  has_many  :audits

  belongs_to :plan
  has_many :invoices # TODO Yagni Invoice model

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :email, format: { :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :username, on: :update, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 24 }, format: { with: /\A[a-z0-9-]+\Z/, message: 'lower case alphanumeric plus hyphen, no spaces.' }, exclusion: { in: USERNAME_EXCLUSIONS, message: "%{value} is reserved."}
  validates :mission, length: { in: 24..280 }, allow_blank: true

  validates :twitter_profile, url: { allow_nil: true, allow_blank: true, no_local: true },    format: { with: /twitter.com/, allow_blank: true}
  validates :linkedin_profile, url: { allow_nil: true, allow_blank: true, no_local: true },   format: { with: /linkedin.com/, allow_blank: true}
  validates :website, url: { allow_nil: true, allow_blank: true, no_local: true }

  def name
    if self.first_name or self.last_name
      self.first_name + ' ' + self.last_name
    end
  end

  def plan_short_name
    self.plan.short_name
    # self.plan.name.split('_').first # was first, then we added intro_ prefix
  end

  def plan_interval
    self.plan.name.split('_').last
  end

  def stripe_customer
    Stripe::Customer.retrieve(id: self.stripe_customer_id) if self.stripe_customer_id
  end

  def first_sub
    Stripe::Customer.retrieve(id: self.stripe_customer_id).subscriptions.first
  end

  def next_invoice
    Stripe::Invoice.upcoming(customer: self.stripe_customer)
  end

  def stripe_subscriptions
    if Stripe::Customer.retrieve(id: self.stripe_customer_id).subscriptions.count != 0
      Stripe::Customer.retrieve(id: self.stripe_customer_id).subscriptions
    else
      nil
    end
  end

  def first_subscription_ends
    sub = Stripe::Customer.retrieve(id: self.stripe_customer_id).subscriptions.first
    Time.at(sub.current_period_end) if sub
  end

  def first_subscription_renews?
    sub = Stripe::Customer.retrieve(id: self.stripe_customer_id).subscriptions.first
    !sub.cancel_at_period_end
  end

  def subscribe_to_stripe(plan,coupon = nil)
    if plan.present? and self.stripe_customer_id.present?
      if coupon and VALID_STRIPE_COUPONS.include? coupon # TODO: validate Coupon against Stripe and abandon the constant
        sub = Stripe::Subscription.create(
            customer:           self.stripe_customer_id,
            coupon:             coupon,
            plan:               plan.stripe_id
        )
      else
        sub = Stripe::Subscription.create(
            customer:           self.stripe_customer_id,
            plan:               plan.stripe_id
        )
        self.update_attribute(:stripe_coupon_code, nil) # they requested an invalid coupon so nil it
      end
      self.update(
        plan_id:              plan.id,
        subscription_state:   sub.status,
        subscribed_at:        Time.now
      )
    end
  end

  def subscription
    if self.subscription_state != 'canceled' # if they're canceled, they can't do stuff.
      self.plan_short_name
    end
  end

  def self.top_page_authors(limit = 10)
    # plan a
    # https://www.krautcomputing.com/blog/2015/01/13/recalculate-counter-cache-columns-in-rails/
    User.where('pages_count > 0').order(pages_count: :desc).limit(limit)

    # plan b
    # https://stackoverflow.com/questions/16996618/rails-order-by-results-count-of-has-many-association
    # User.left_joins(:pages).group(:id).order('count(pages.author_id) desc').limit(limit)
  end

  def admin?
    self.role == 'admin'
  end

  def associate?
    self.plan_short_name == 'associate'
  end

  def team_role(company)
    CompanyUser.where(company_id: company.id, user_id: self.id).pluck(:role)[0] # fetch from array
  end

  # Can I message this person?
  #  Am I on the right plan?                  free with admin, alliance, company. not with jet
  #  Are we conversing?
  #  Am I on a team with them?
  def messagable_by(current_user)
    true  if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions } or
          Conversation.between(self.id,current_user.id).present? or
          CompanyUser.team_mates(self.id,current_user.id) or
          AllianceUser.team_mates(self.id,current_user.id)
  end

  def conversations
    Conversation.includes?(self)
  end

  def unread_message_count
    i = 0
    conversations.each do |c|
      c.messages.each do |m|
        if m.author != self and m.read == false
          i += 1
        end
      end
    end
    i
  end

  # part of guest user
  def password_required?
    super if confirmed?
  end

  # part of guest user
  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

end
