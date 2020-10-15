require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  def signed_in?
    false
  end

  test 'displays sign in link when user is not logged in' do
    assert_match 'Sign In', sign_in_or_out_link
  end

  test 'displays sign out link when user is logged in' do
    skip("See https://stackoverflow.com/questions/53514537/how-to-test-a-rails-5-helper-that-relies-on-devise-signed-in-helper-with-minit")
    assert_match 'Sign Out', sign_in_or_out_link
  end

end
