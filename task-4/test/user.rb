require_relative 'test_helper'
require_relative '../lib/user'

describe User do
  include TestHelper

  it "should make it possible to find user by surname" do
    user = User.find_by_surname('Bajur')
    user.surname.should == "Bajur"
  end

  it "should make it possible to find user by email" do
    user = User.find_by_email('mbajur@gmail.com')
    user.email.should == 'mbajur@gmail.com'
  end

  it "should make it possible to find user by prefix of their surname" do
    user = User.find_by_surname_prefix("Baj")
    user.surname.should == 'Bajur'
  end

  it "should authenticate user using email and encrypted password" do
    user = User.authenticate('mbajur@gmail.com', 'password')

    user.should == true
  end

  it "should find suspicious users with more than 2 failed_login_counts" do
    user = User.find_suspicious
    user.length.should > 0
  end

  it "should group users by number of failed login attempts" do
    User.suspicious.length.should > 0
    User.unsuspicious.length.should > 0
  end

end
