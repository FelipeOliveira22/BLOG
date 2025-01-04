require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: "lipenogueira33@gmail.com", password: "96334505")
  end

  test "should login user" do
    post login_path, params: { email: @user.email, password: "96334505" }
    assert_redirected_to posts_path
    assert_equal @user.id, session[:user_id]
  end

  test "should logout user" do
    login_as(@user)
    delete logout_path
    assert_redirected_to login_path
    assert_nil session[:user_id]
  end

  test "should not login with invalid credentials" do
    post login_path, params: { email: @user.email, password: "wrong_password" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end
end
