
# 3 day grace period before cancellation

namespace :subscription do

  desc 'mark past_due subscription_state on day of expiry'
  task state_past_due: :environment do
    users = User.where('subscription_expires_at < ?',Time.now.end_of_day).all
    users.update_all(subscription_state: 'past_due')
    puts 'marked: ' + users.count.to_s
  end

  desc 'mark canceled subscription_state 3 days after expiry'
  task state_canceled: :environment do
    users = User.where('subscription_expires_at < ?',Time.now.end_of_day-3.days).all
    users.update_all(subscription_state: 'canceled')
    puts 'marked: ' + users.count.to_s
  end

end