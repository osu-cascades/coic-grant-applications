require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test 'valid company' do
    c = Company.new(business_name: "test")
    assert c.valid?
  end
end
