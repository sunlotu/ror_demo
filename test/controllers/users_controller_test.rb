require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create users" do
    assert_difference('User.count') do
      post users_url, params: {users: {email: @user.email, encrypted_password: @user.encrypted_password, name: @user.name, password_salt: @user.password_salt, remember_digest: @user.remember_digest } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show users" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update users" do
    patch user_url(@user), params: {users: {email: @user.email, encrypted_password: @user.encrypted_password, name: @user.name, password_salt: @user.password_salt, remember_digest: @user.remember_digest } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy users" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
