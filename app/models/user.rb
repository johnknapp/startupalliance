class User < ApplicationRecord
  include Pid
  has_many  :company_users
  has_many  :companies, through: :company_users
  has_many  :alliance_users
  has_many  :alliances, through: :alliance_users
  has_many  :user_traits
  has_many  :traits, through: :user_traits
  has_many  :user_skills
  has_many  :skills, through: :user_skills

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :email, format: { :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :username, on: :update, uniqueness: { case_sensitive: false }, presence: true, length: { maximum: 24 }, format: { with: /\A[a-z0-9-]+\Z/, message: 'lower case alphanumeric plus hyphen, no spaces.' }, exclusion: { in: USERNAME_EXCLUSIONS, message: "%{value} is reserved."}
  validates :mission, length: { in: 24..140 }, allow_blank: true

  validates :twitter_profile, url: { allow_nil: true, allow_blank: true, no_local: true },    format: { with: /twitter.com/, allow_blank: true}
  validates :linkedin_profile, url: { allow_nil: true, allow_blank: true, no_local: true },   format: { with: /linkedin.com/, allow_blank: true}
  validates :website, url: { allow_nil: true, allow_blank: true, no_local: true }

  def name
    if self.first_name or self.last_name
      self.first_name + ' ' + self.last_name
    end
  end

  def team?(company)
    company.team.include? self
  end

  def member?(alliance)
    alliance.members.include? self
  end

  def admin?
    self.role == 'admin'
  end

  def skill_index
    arr = []
    user_skills = self.user_skills
    user_skills.each do |us|
      arr << us.level
    end
    arr.sum
  end

  def trait_index
    arr = []
    user_traits = self.user_traits
    user_traits.each do |ut|
      arr << ut.level
    end
    arr.sum
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
