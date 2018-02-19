#
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
# https://github.com/CanCanCommunity/cancancan/wiki/Checking-Abilities
#

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read,                                                to: :cr
    alias_action :create, :read, :update,                                       to: :cru
    alias_action :create, :read, :update, :destroy,                             to: :crud
    alias_action :index, :create, :read, :update, :destroy,                     to: :crudi
    alias_action :add_alliance_member, :remove_alliance_member,                 to: :manage_members
    alias_action :add_team_member, :update_team_member, :remove_team_member,    to: :manage_team

    primary_objects = [Alliance,Company,Conversation,Message,Discussion,Post,Okr,AllianceUser,CompanyUser,CompanySakpi,UserSkill,UserTrait]
    public_content  = [Alliance,Company] # user profiles are public by default

    case user.role

      when 'admin'
        can :manage,                [:all]

      # Watch for current_user.plan_name conditionals all over the place!

      when 'user'
        cannot :index,              primary_objects
        can :crud,                  primary_objects
        can :crudi,                 Page
        can :dashboard,             Company
        can :set_sakpi,             Company
        can :unset_sakpi,           Company
        can :manage_members,        Alliance
        can :manage_team,           Company
        # seems skills and traits can be set and unset on user

      else # no role means they are non-auth
        cannot :index,              primary_objects
        can :read,                  public_content
        can :show,                  Discussion

    end
  end
end
