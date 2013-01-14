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

## Gotchas

### Deadlocks

If your block touches other tables, and you use table-level locking on those tables as well,
read up about [deadlocks](http://en.wikipedia.org/wiki/Deadlock). **You have been warned.**

### MySQL and related models

If your model has ```before_save``` or ```after_save``` hooks that write to other tables, you'll
find that MySQL complains that ```Table 'x' was not locked with LOCK TABLES```.

Add that related model to make with_table_lock also lock that table automatically:

``` ruby
class Tag < ActiveRecord::Base
  also_lock_models :tag_audit
  after_save do
    TagAudit.create do |ea|
      ea.tag_name = name
    end
  end
end

class TagAudit < ActiveRecord::Base
end
```

You can pass either the class or the symbol of your model to ```also_lock_models```.

If you have a specific table name, rather than an ActiveRecord model,
use ```also_lock_table_names``` instead.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'monogamy'
```

And then execute:

    $ bundle

## Changelog

### 0.0.2

* Added support for ```also_lock_models``` and ```also_lock_tables```

### 0.0.1

* First whack
