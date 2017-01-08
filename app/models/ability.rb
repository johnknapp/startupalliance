#
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
# https://github.com/CanCanCommunity/cancancan/wiki/Checking-Abilities
#

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read,                                to: :cr
    alias_action :create, :read, :update,                       to: :cru
    alias_action :create, :read, :update, :destroy,             to: :crud

    case user.role

      when 'admin'
        can :manage,                [:all]

      when 'builder'

      when 'booster'

      when 'associate'

      when 'user'

      else # no user means they are a non-auth guest

    end
  end
end
