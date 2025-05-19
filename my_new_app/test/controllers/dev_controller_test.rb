require "test_helper"

class DevControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_index_url
    assert_response :success
  end
end
