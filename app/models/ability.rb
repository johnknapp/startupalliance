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

    primary_objects = [Alliance,Company,Okr,AllianceUser,CompanyUser,CompanySakpi,UserSkill,UserTrait]
    content         = [Alliance,Company,Okr]

    case user.role

      when 'admin'
        can :manage,                [:all]

      when 'user'
        cannot :index,              primary_objects
        can crud,                   primary_objects
        can :set_sakpi,             Company
        can :unset_sakpi,           Company

      else # no role means they are non-auth
        cannot :index,              primary_objects
        can :read,                  content

    end
  end
end
