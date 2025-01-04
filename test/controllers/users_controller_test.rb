require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Certifique-se de ter uma fixture para usuários
  end

  test "should get edit" do
    login_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    login_as(@user)
    patch user_url(@user), params: { user: { name: "Novo Nome", email: @user.email } }
    assert_redirected_to profile_path
    @user.reload
    assert_equal "Novo Nome", @user.name
  end

  test "should get profile" do
    login_as(@user)
    get profile_path
    assert_response :success
  end
end
