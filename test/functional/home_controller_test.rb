require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get make_ticket" do
    get :make_ticket
    assert_response :success
  end

end
