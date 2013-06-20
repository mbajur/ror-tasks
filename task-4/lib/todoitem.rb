require 'active_record'

class Todoitem < ActiveRecord::Base
  belongs_to :todolist

  validates :title, :presence => true, :length => { :minimum => 5, :maximum => 30 }
  validates :todolist_id, :presence => true
  validates :description, :length => { :maximum => 255 }

  def self.search_for_keyword(keyword)
  	Todoitem.where("description like ?", "%" << keyword << "%")
  end

  def self.get_with_description_longer_than(length)
  	items = Todoitem.all
  	items.each do |i|
  		if i.description.length <= length
        items.delete(i)
      end
  	end
  	items
  end

  def self.page(page)
    per_page = 5
    items = self.all(offset: per_page*page, limit: per_page)
  end

  def self.find_for_user(user_id)
    items = User.find(user_id).todoitems
  end

  def self.find_for_user_and_date(user_id, date)
    date = date.strftime("%d-%m-%Y")
    items = self.find_for_user(user_id).where(:date_due => date)
    items
  end

  def self.find_for_day(date)
    date = date.strftime("%d-%m-%Y")
    items = self.where(:date_due => date)
    items
  end

  def self.find_for_week(date)
    items = Todoitem.where('date_due > ? and date_due < ?', date.at_beginning_of_week, date.at_end_of_week)
    items
  end

  def self.find_for_month(date)
    items = Todoitem.where('date_due > ? and date_due < ?', date.at_beginning_of_month, date.at_end_of_month)
    items
  end

  def self.find_overdued
    items = Todoitem.where('date_due > ?', Time.now)
    items
  end

  def self.find_due_for_next_hours(hours)
    items = Todoitem.where('date_due > ? and due_date < ?', Time.now, Time.now + hours.hours)
    items
  end
end