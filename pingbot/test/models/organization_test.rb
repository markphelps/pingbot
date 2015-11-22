require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "token is generated before_create" do
    organization = Organization.new(name: "test")
    organization.save!

    refute_nil organization.token
  end
end
