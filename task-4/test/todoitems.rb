require_relative 'test_helper'
require_relative '../lib/todolist'
require_relative '../lib/todoitem'
require_relative '../lib/user'

describe Todoitem do
  include TestHelper

  it "should find items with a specific word in a description" do
    items = Todoitem.search_for_keyword('description')
    items.length.should > 0
  end

  it "should find items with description exceeding 100 characters" do
    items = Todoitem.get_with_description_longer_than(100)
    items.length.should > 0
  end

  it "should paginate items with 5 items per page and order them by title" do
    items = Todoitem.page(0)
    items.length.should > 0
  end

  it "should find all items that belong to a given user" do
    items = Todoitem.find_for_user(1)
    items.length.should > 0
  end

  it "should find items that belong to to a specific user that are due to midnight of a specific day" do
    items = Todoitem.find_for_user_and_date(1, Time.now)
    items.length.should > 0
  end

  it "should find items that are due for a specific day" do
    items = Todoitem.find_for_day(Time.now)
    items.length.should > 0
  end

  it "should find items that are due for a specific week" do
    items = Todoitem.find_for_week(Time.now)
    items.length.should > 0
  end

  it "should find items that are due for a specific month" do
    items = Todoitem.find_for_month(Time.now)
    items.length.should > 0
  end

  it "should find items that are overdue" do
    items = Todoitem.find_overdued
    items.length.should > 0
  end

  it "should find items that are due in the next n hours" do
    items = Todoitem.find_due_for_next_hours(10)
  end

end
