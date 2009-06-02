require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  
  def no_test #{}"Donor email must be confirmed" do
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => nil})
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => "foo@bar.com"})
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => "a@b.com"})
    assert donor.valid?
  end
  
  test "Donor login is email" do
    donor = create_a_donor(:login => "foo@bar.com", :email_confirmation => "foo@bar.com")
    isValid = donor.valid?
    donor.errors.each {|e, m| puts "Error: #{e} #{m}"}
    assert_equal donor.login, donor.email
  end
  
  test "get the list of donations_given" do
    donor = users(:donor)
    assert donor.all_donations_given.size == 2
    assert donor.donations_given.size == 2
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end

    donor2 = users(:donor2)
    assert donor2.all_donations_given.size == 2
    assert donor2.donations_given.size == 2
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end

    donor3 = users(:donor3)
    assert donor3.all_donations_given.size == 2
    assert donor3.donations_given.size == 0
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end
  end

  test "get a list of savers that the donor has given to" do
    donor = users(:donor)
    beneficiaries = donor.beneficiaries
    assert !beneficiaries.empty?
    assert beneficiaries.size > 0
    beneficiaries.each do |party|
      assert party.class == Saver
    end
  end
  
  protected
    def create_a_donor(options = {})
      Donor.new({
        :login => "foobar",
        #:email => "a@b.com",
        :email_confirmation => "a@b.com",
        :password => "foo2thebar",
        :password_confirmation => "foo2thebar",
        :birthday => 21.years.ago
        }.merge(options))
    end

end
