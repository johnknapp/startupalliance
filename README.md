# Dev setup:

## Requirements:

 - install pow (http://pow.cx)
 - install rvm (https://rvm.io)
 - install postgres

## Setup POW:

Make a symlink telling pow where the app lives

```
$ cd ~/.pow (puma-dev)
$ ln -s /path/to/the_app <symlink_name>
```

## Initial Setup:

 1. Make sure rvm creates the gemset when you cd into app directory
 1. Install the required ruby version
 1. Install the bundler gem
 1. Install the gems using bundler
 1. Create, migrate and seed your db

```
$ cd /path/to/the_app
$ rvm install 2.3.1
$ gem install bundler
$ bundle install
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

## Run the app:

In your browser, visit <symlink_name>.test/

There are seeds for users

## Monitor pow server logs:

$ tail -f ~/Library/Logs/Pow/apps/startup_alliance.log

## Monitor puma-dev server logs:

$ tail -f ~/Library/Logs/puma-dev.log

## Monitor rails logs:

$ tail -f log/development.log

## Subscriptions and Stripe:

1. Join/Subscribe: Update user and create Stripe Customer and Subscription objects
1. Trial period ending: Email user to make sure they have a card on file
1. Invoice payment: Email on success or failure, update user.subscription_state to active or past_due
1. Subscription renewal: Email on payment success or failure, update user.subscription_state to active or past_due
1. Payment attempt failure: Cancel and downgrade to Associate. (WIP on 4/18/18)
1. User cancel: Downgrade to Associate. (WIP on 4/18/18)
1. Upgrade / Downgrade: (WIP on 4/18/18)