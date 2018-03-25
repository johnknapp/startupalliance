class GibbonService
  def self.add_update(user, list_id)
    if Rails.env.production? and user.email.present?
      md5_email = Digest::MD5.hexdigest(user.email.downcase)
      planname = user.plan_name
      $gibbon.lists(list_id).members(md5_email).upsert(
        body: {
          email_address: user.email,
          status: 'subscribed',
          merge_fields: {
            FNAME:    user.first_name,
            LNAME:    user.last_name,
            USERNAME: user.username,
            STATE:    user.state,
            PLAN:     planname,
            ACQSRC:   user.acqsrc
          }
        }
      )
    end
  rescue => e
  end

  def self.unsubscribe(user, list_id)
    md5_email = Digest::MD5.hexdigest(user.email.downcase)
    if Rails.env.production? and user.email.present?
      $gibbon.lists(list_id).members(md5_email).update(
        body: { status: 'unsubscribed' }
      )
    end
    rescue => e
  end

end

