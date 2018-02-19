module ForumsHelper

  def discussion_summary(discussion)
    '(' + discussion.topics.count.to_s + ' Topic'.pluralize(discussion.topics.count) +
    if discussion.topics.count != 0
      if disco_posts(discussion).count == 0
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) + ' — You can post first!)'
      else
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) +
        ' — latest ' + time_ago_in_words(disco_posts(discussion).order(updated_at: :desc).limit(1).last.updated_at) + ' ago)'
      end
    else
      ' — You can post first!)'
    end
  end

  def topic_summary(topic)
    '(' + topic.posts.count.to_s + ' ' + 'Post'.pluralize(topic.posts.count) +
    if topic.posts.count != 0
      ' — latest ' + time_ago_in_words(topic.posts.order(updated_at: :desc).limit(1).last.updated_at)+' ago)'
    else
      ' — You can post first!)'
    end
  end

  def nucleus_forum_posts
    topic_ids = nucleus_topics.pluck(:id)
    Post.where('topic_id in (?)', topic_ids)
  end

  def nucleus_forum_authors
    1234
  end

  def nucleus_topics
    nuc_disco_ids = Discussion.where(nucleus: true).pluck(:id)
    Topic.where('discussion_id in (?)',nuc_disco_ids)
  end

  private

    def disco_posts(discussion)
      topic_ids = Topic.where(discussion_id: discussion.id).all.pluck(:id)
      posts = Post.where('topic_id in (?)', topic_ids).all
    end

end