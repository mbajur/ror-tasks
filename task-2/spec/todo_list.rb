require 'spec_helper'
require 'lib/todo_list'
require 'lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(:db => database, :network => network) }
  let(:database)            { stub }
  let(:network)             { stub }
  let(:item)                { Struct.new(:title,:description, :complete).new(title,description,false) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(:db => nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    stub(database).items_count { 6 }
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }
    mock(network).notify

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    stub(database).get_todo_item(0) { item }
    mock(database).complete_todo_item(item, true) { item.complete = true; true }
    mock(database).complete_todo_item(item, false) { item.complete = false; true }
    mock(network).notify
    mock(network).notify

    list.toggle_state(0)
    item.complete.should be_true
    list.toggle_state(0)
    item.complete.should be_false
  end

  it "should fetch the first item from the DB" do
    stub(database).items_count { 6 }
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  it "should return nil for the first and the last item if the DB is empty" do
    stub(database).items_count { 0 }

    list.first.should == nil
    list.last.should  == nil
  end

  it "raising an exception when changing the item state if the item is nil" do
    mock(database).get_todo_item(5) { nil }
    
    expect{ list.toggle_state(5) }.to raise_error(ItemNil)
  end

  it "should not accept a nil item" do
    (list << nil).should be_false
  end

  it "should notify a social network if an item is added to the list" do
    mock(database).add_todo_item(item) { true }
    mock(network).notify

    (list << item).should be_true
  end

  context "with too short (not empty) title" do
    let(:title) { "a" }

    it "should not accept an item" do
      (list << item).should be_false
    end
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  context "with empty description" do
    let(:title) { "Testowy tytul" }
    let(:description) { "" }

    it "should accept item" do
      mock(database).add_todo_item(item) { true }
      mock(network).notify

      (list << item).should be_true
    end
  end
end
