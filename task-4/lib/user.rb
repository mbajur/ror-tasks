require 'active_record'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ActiveRecord::Base
  has_many :todolists
  has_many :todoitems, :through => :todolists

  attr_accessible :surname

  validates :name, :presence => true, :length => { :maximum => 20 }
  validates :surname, :presence => true, :length => { :maximum => 30 }
  validates :email, :presence => true, :email => true
  validates :terms_of_service, :acceptance => true, :on => :create
  validates :password, :presence => true, :length => { :minimum => 10 }, :confirmation => true
  validates :failed_login_count, :presence => true, :on => :create

  scope :suspicious, where("failed_login_count > 2")
  scope :unsuspicious, where("failed_login_count <= 0")

  def self.authenticate(email, password)
    require 'digest/md5'
    md5_password = Digest::MD5.hexdigest(password)

    user = self.where(:email => 'mbajur@gmail.com', :password => md5_password)
    if user.present?
      true
    else
      false
    end
  end

  def self.find_suspicious
    self.where("failed_login_count > 2")
  end

  def self.find_by_surname_prefix(prefix)
    self.where("surname like ?", prefix << "%").first
  end
end