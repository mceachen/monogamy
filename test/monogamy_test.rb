require 'minitest_helper'

describe "Monogamy" do

  it "adds with_table_lock to ActiveRecord classes" do
    assert Tag.respond_to?(:with_table_lock)
  end

  it "adds with_table_lock to ActiveRecord instances" do
    assert Tag.new.respond_to?(:with_table_lock)
  end

  def find_or_create_at_even_second(run_at, with_table_lock)
    Tag.connection.close
    sleep(run_at - Time.now.to_f)
    Tag.connection.reconnect!
    if with_table_lock
      Tag.with_table_lock do
        Tag.find_or_create_by_name(run_at.to_s)
      end
    else
      t = Tag.new
      t.name = run_at.to_s
      t.save! unless Tag.find_by_name(run_at.to_s)
    end
  end

  def run_workers(with_table_lock)
    start_time = Time.now.to_i + 1
    threads = @workers.times.collect do
      Thread.new do
        begin
          @iterations.times do |ea|
            find_or_create_at_even_second(start_time + ea, with_table_lock)
          end
        ensure
          ActiveRecord::Base.connection.close
        end
      end
    end
    threads.each { |ea| ea.join }
  end

  before :each do
    @iterations = 5
    @workers = 10
  end

  it "parallel threads create multiple duplicate rows" do
    run_workers(with_table_lock = false)
    if Tag.connection.adapter_name == "SQLite"
      Tag.all.size.must_equal @iterations # <- we're just making sure it runs. SQLite isn't concurrent.
    else
      Tag.all.size.must_be :>, @iterations # <- any duplicated rows will make me happy.
    end
  end

  it "parallel threads with_table_lock don't create multiple duplicate rows" do
    run_workers(with_table_lock = true)
    Tag.all.size.must_equal @iterations # <- any duplicated rows will NOT make me happy.
  end
end
