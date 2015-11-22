require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = organizations(:one)
    setup_auth_token(@organization.token)
  end

  test "should show organization" do
    get :show, id: @organization
    assert_response :success
  end

  test "should update organization" do
    put :update, id: @organization, organization: { name: @organization.name }
    assert_response 204
  end
end
