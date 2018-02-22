module Unread
  extend ActiveSupport::Concern
  included do


    # mark these posts as unread by current_user

    # posts.mark_as_read! :all, for: current_user

  end
end
