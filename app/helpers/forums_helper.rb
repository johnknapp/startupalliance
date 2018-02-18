module ForumsHelper

  # def posts_count(discussion)
  #   count = 0
  #   discussion.topics.each do |t|
  #     count += t.posts.count
  #   end
  #   count
  # end
  #
  # def most_recent_post(model)
  #   if model.class.name == 'Discussion'
  #     topic_ids = Topic.where(discussion_id: model.id).all.pluck(:id)
  #     Post.where('topic_id in (?)', topic_ids).order(updated_at: :desc).limit(1).last
  #   elsif model.class.name == 'Topic'
  #     model.posts.order(updated_at: :desc).limit(1).last
  #   end
  # end
  #
  def discussion_summary(discussion)
    '(' + discussion.topics.count.to_s + ' Topic'.pluralize(discussion.topics.count) +
    if discussion.topics.count != 0
      if disco_posts(discussion).count == 0
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) + ')'
      else
        ', ' + disco_posts(discussion).count.to_s + ' ' +
        'Post'.pluralize(disco_posts(discussion).count) +
        ' — latest ' + time_ago_in_words(disco_posts(discussion).order(updated_at: :desc).limit(1).last.updated_at) + ' ago)'
      end
    else
      ')'
    end
  end

  def topic_summary(topic)
    '(' + topic.posts.count.to_s + ' ' + 'Post'.pluralize(topic.posts.count) +
    if topic.posts.count != 0
      ' — latest ' + time_ago_in_words(topic.posts.order(updated_at: :desc).limit(1).last.updated_at)+' ago)'
    else
      ')'
    end
  end

  private

    def disco_posts(discussion)
      topic_ids = Topic.where(discussion_id: discussion.id).all.pluck(:id)
      posts = Post.where('topic_id in (?)', topic_ids).all
    end

end