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

  test "invalid without name" do
    o = Owner.new(
      percent_ownership: "test",
      race: "test",
      ethnicity: "test",
      gender: "test"
    )

    refute o.valid?
  end

  test "invalid without demographic data" do
    o = Owner.new(
      name: "test",
      percent_ownership: "test"
    )

    refute o.valid?
  end
end
