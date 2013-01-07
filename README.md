# Monogamy [![Build Status](https://api.travis-ci.org/mceachen/monogamy.png?branch=master)](https://travis-ci.org/mceachen/monogamy)

Adds table-level locking to ActiveRecord 3.x. MySQL, PostgreSQL, and SQLite are supported.

## Usage

```ruby
Tag.with_table_lock do
  Tag.find_or_create_by_name("example")
end
```

While your code is inside the block, it will have exclusive read and write access to the model's
table.

If your block touches other tables, and you use table-level locking on those tables as well,
read up about [deadlocks](http://en.wikipedia.org/wiki/Deadlock). **You have been warned.**

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'monogamy'
```

And then execute:

    $ bundle

## Changelog

### 0.0.1

* First whack
