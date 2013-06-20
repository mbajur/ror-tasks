require 'active_record'

class Todolist < ActiveRecord::Base
  belongs_to :user
  has_many :todoitems

  validates :title, :presence => true
  validates :user_id, :presence => true

  def self.find_by_title_prefix(prefix)
    lists = self.where("title like ?", prefix << "%")
  end

  def self.find_by_user_id(user_id)
    Todolist.where(:user_id => user_id)
  end

  def self.find_by_id_with_items(list_id)
    self.find(list_id)
  end
end