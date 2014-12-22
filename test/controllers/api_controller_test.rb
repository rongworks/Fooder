require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @auth_header = "Token token=#{api_keys(:one)}";
  end

  test 'should generate key for user' do
    user = users(:one)
    user.get_api_key
    assert_not_nil user.api_key
  end

  test 'checkin should create new product' do
    # curl --data "code:123456767" http://localhost:3000/check_in.json -H 'Authorization: Token token="f7f6561c9ddcaaf30f49a01180c8c1c0"'
    #@request.headers["Authorization Token"] = "#{api_keys(:one)}"
    params={code: 1234}
    post 'check_in', params.to_json, {format: :json, 'Authorization' => @auth_header }
    assert_response :success, "response #{response.status} for user #{users(:one).api_key}"
    assert_not_empty Product.where(code: '1234'), 'Product should have been created'
  end

end
