require 'test_helper'

class PingsControllerTest < ActionController::TestCase
  setup do
    @ping = pings(:one)
    setup_auth_token(@ping.organization.token)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pings)
  end

  test "should create ping" do
    assert_difference('Ping.count') do
      post :create, ping: { name: @ping.name, description: @ping.description }
    end

    assert_response 201
  end

  test "should show ping" do
    get :show, id: @ping
    assert_response :success
  end

  test "should update ping" do
    put :update, id: @ping, ping: { name: @ping.name, description: @ping.description }
    assert_response 204
  end

  test "should destroy ping" do
    assert_difference('Ping.count', -1) do
      delete :destroy, id: @ping
    end

    assert_response 204
  end

  test "should allow healthy" do
    get :healthy, id: @ping
    assert_response :ok
  end

  test "should allow inactive" do
    get :inactive, id: @ping
    assert_response :ok
  end
end
