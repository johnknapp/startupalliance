module PostsHelper
  def nested_posts(posts) # posts is a nested hash from the ancestry arrange method
    posts.map do |post, sub_posts|
      render('post/show_modal', post: post) + content_tag(:div, nested_posts(sub_posts), class: 'nested_posts')
    end.join.html_safe
  end
end