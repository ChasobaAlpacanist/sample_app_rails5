require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:'', email:'foo@invalid',
                                  password:'foo',
                                  password_confirmation:'bar' } }
    assert_template 'users/edit'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    new_name = 'Foo Bar'
    new_email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:new_name, email:new_email,
                    password:'password',
                    password_confirmation:'password' } }
    assert_not flash.empty? #assert_notはfalseを返して欲しいテストを指す。
    assert_redirected_to @user
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email

  end
end
