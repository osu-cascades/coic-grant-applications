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

  test 'invalid without round' do
    a = Application.new(
      jobs_retained: "test",
      amount_approved: "test",
    )   

    refute a.valid?
  end
end
