require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  test 'valid application' do
    a = Application.new(
      round: "test",
      jobs_retained: "test",
      amount_approved: "test",
    )

    assert a.valid?
  end
end
