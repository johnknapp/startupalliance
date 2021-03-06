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
    alias_action :join_alliance, :add_alliance_member, :remove_alliance_member, to: :manage_members
    alias_action :add_team_member, :update_team_member, :remove_team_member,    to: :manage_team

    primary_objects = [Alliance,Company,Conversation,Message,Discussion,Post,Okr,AllianceUser,CompanyUser,CompanySakpi,UserSkill,UserTrait]
    public_content  = [Alliance,Company] # user profiles are public by default

    case user.role

      when 'admin'
        can :manage,                [:all]

      # Watch for current_user.plan_short_name conditionals all over the place!

      when 'user'
        cannot :index,              primary_objects
        can :crud,                  primary_objects
        can :crudi,                 Classified
        can :crudi,                 Page
        can :like,                  Page
        can :dislike,               Page
        can :dashboard,             Company
        can :set_sakpi,             Company
        can :unset_sakpi,           Company
        can :join_alliance,         Alliance
        can :remove_alliance_member, Alliance
        can :manage_members,        Alliance, creator_id: user.id
        can :manage_team,           Company,  creator_id: user.id
        can :search_results,        Discussion
        can :mark_posts_read,       Post
        can :mark_post_read,        Post
        can :remove_alliance_member,  Alliance # TODO only if they're removing themself
        # seems skills and traits can be set and unset on user

      else # they have no role which means they are non-auth
        cannot :index,              primary_objects
        can :featured,              Page
        can :read,                  public_content
        can :show,                  Discussion
        can :search_results,        Discussion
    end
  end
end
