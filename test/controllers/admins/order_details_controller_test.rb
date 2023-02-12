require "test_helper"

class Admins::OrderDetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get admins_order_details_update_url
    assert_response :success
  end
end
