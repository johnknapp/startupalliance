module ForumsHelper

  def nested_posts(posts) # posts is a nested hash from the ancestry arrange method
    posts.map do |post, sub_posts|
      render('post/show', post: post) + content_tag(:div, nested_posts(sub_posts), class: 'nested_posts')
    end.join.html_safe
  end

  def discussion_meta(discussion)
    discussion.topics.count.to_s + ' Topic'.pluralize(discussion.topics.count) +
    if discussion.topics.count != 0
      if disco_posts(discussion).count == 0
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) + ' — You can post first!'
      else
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) +
        ' — latest ' + time_ago_in_words(disco_posts(discussion).order(updated_at: :desc).limit(1).last.updated_at) + ' ago'
      end
    else
      ' — You can post first!'
    end
  end

  def topic_meta(topic)
    # topic.posts.count.to_s + ' ' + 'Post'.pluralize(topic.posts.count) +
    if topic.posts.count != 0
      ' Latest post ' + time_ago_in_words(topic.posts.order(updated_at: :desc).limit(1).last.updated_at)+' ago'
    else
      ' You can post first!'
    end
  end

  def unread_posts_count(discussions,user)
    pq = Post
    discussions.each do |discussion|
      discussion.posts
      pq =  pq.where('posts.id in (?)', discussion.posts.pluck(:id)) # add where clauses
    end
    pq.unread_by(user).count
  end

  def nucleus_forum_posts
    topic_ids = nucleus_topics.pluck(:id)
    Post.where('topic_id in (?)', topic_ids)
  end

  def nucleus_forum_post_author_ids
    nucleus_forum_posts.pluck(:author_id).uniq.count
  end

  def nucleus_topics
    nuc_disco_ids = Discussion.where(nucleus: true).pluck(:id)
    Topic.where('discussion_id in (?)',nuc_disco_ids)
  end

  def discussable_topics(discussable)
    discussion_ids = discussable.discussions.pluck(:id)
    Topic.where('discussion_id in (?)',discussion_ids)
  end

  private

    def disco_posts(discussion)
      topic_ids = Topic.where(discussion_id: discussion.id).all.pluck(:id)
      posts = Post.where('topic_id in (?)', topic_ids).all
    end

end