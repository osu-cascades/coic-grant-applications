require 'test_helper'

class OwnerTest < ActiveSupport::TestCase
  test "valid owner" do
    o = Owner.new(
      name: "test",
      percent_ownership: "test",
      race: "test",
      ethnicity: "test",
      gender: "test"
    )

    assert o.valid?
  end
end
