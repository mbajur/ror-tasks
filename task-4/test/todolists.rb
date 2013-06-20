require_relative 'test_helper'
require_relative '../lib/todolist'
require_relative '../lib/todoitem'

describe Todolist do
  include TestHelper

  it "should find list by prefix of the title" do
    list = Todolist.find_by_title_prefix('First')
    list.present?.should == true
  end

  it "should find all lists that belong to a given user" do
    lists = Todolist.find_by_user_id(1)
    lists.length.should > 0
  end

  it "should find list by id eagerly loading its listitems" do
    list = Todolist.find_by_id_with_items(1)

    list.nil?.should == false
    list.todoitems.length.should > 0
  end

end
