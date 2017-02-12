# Dev setup:

## Requirements:

 - install pow (http://pow.cx)
 - install rvm (https://rvm.io)
 - install postgres

## Setup POW:

Add the path to the app

```
$ cd ~/.pow
$ ln -s /path/to/the_app <symlink_name>
```

## Initial Setup

```
$ cd /path/to/the_app
$ rvm install 2.3.1
$ bundle install
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

## Run the app

In your browser, visit <symlink_name>.dev