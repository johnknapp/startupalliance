class Vote < ApplicationRecord

  # gem supports cache counters on votable

  # current_user.likes    @page    Note: Duplicates are ignored
  # current_user.dislikes @page    Note: Will remove an earlier like

  # Alternative:
  # @page.liked_by        current_user
  # @page.disliked_by     current_user

  # @page.get_likes.size
  # @page.get_dislikes.size

end