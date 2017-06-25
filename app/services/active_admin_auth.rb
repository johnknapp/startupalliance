class ActiveAdminAuth < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    if user
      user.admin?
    else
      false
    end
  end

end
