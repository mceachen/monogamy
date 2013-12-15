# Monogamy

Adds table-level locking to ActiveRecord 3.2 and 4.0. MySQL and PostgreSQL are supported.

[![Build Status](https://api.travis-ci.org/mceachen/monogamy.png?branch=master)](https://travis-ci.org/mceachen/monogamy)
[![Gem Version](https://badge.fury.io/rb/monogamy.png)](http://rubygems.org/gems/monogamy)
[![Dependency Status](https://gemnasium.com/mceachen/monogamy.png)](https://gemnasium.com/mceachen/monogamy)

## Usage

```ruby
Tag.with_table_lock do
  Tag.find_or_create_by_name("example")
end
```

While your code is inside the block, it will have exclusive read and write access to the model's
table.

A transaction will be opened and closed for you automatically during your block's execution.
There's no need to wrap your call to ```with_table_lock``` with a ```transaction do```.

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
