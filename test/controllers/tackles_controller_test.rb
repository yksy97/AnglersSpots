require "test_helper"

class TacklesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get tackles_new_url
    assert_response :success
  end

  test "should get create" do
    get tackles_create_url
    assert_response :success
  end

  test "should get edit" do
    get tackles_edit_url
    assert_response :success
  end

  test "should get update" do
    get tackles_update_url
    assert_response :success
  end

  test "should get destroy" do
    get tackles_destroy_url
    assert_response :success
  end
end
