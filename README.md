# Restaurant api


## Installation Guide

Install the Ruby, Rails and PostgreSql versions from https://gorails.com/setup

### Clone the repository

```shell
git clone https://github.com/aawahab90/restaurants_api.git
cd project
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should be `2.4.0`

### Check your Rails version

```shell
 rails -v
```

The ouput should be `Rails 5.2.1`


### Check your Postgres version

```shell
 postgres --version
```

The ouput should be `postgres (PostgreSQL) 9.6.2`


### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle
```

### Set environment variables


See [.env] and contact the developer: [aawahab90@gmail.com](mailto:aawahab90@gmail.com) (sensitive data).

### Initialize the database

```shell
rails db:create db:migrate
```

## Server

```shell
rails s
```

## Test cases

### Check if qt is installed on system

```shell
which qmake
```

If not then install it from https://doc.qt.io/qt-5/gettingstarted.html

## Run test cases

```shell
rspec spec
```

