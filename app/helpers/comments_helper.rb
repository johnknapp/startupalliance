module CommentsHelper
  def nested_comments(comments)
    # comments is a nested hash from the ancestry arrange method
    comments.map do |comment, sub_comments|
      render('partials/comment', comment: comment) + content_tag(:div, nested_comments(sub_comments), class: 'nested_comments')
    end.join
  end
end