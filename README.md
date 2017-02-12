# Dev setup:

## Requirements:

 - install pow (http://pow.cx)
 - install rvm (https://rvm.io)
 - install postgres

## Setup POW:

Make a symlink telling pow where the app lives

```
$ cd ~/.pow
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

In your browser, visit <symlink_name>.dev

There are seeds for users