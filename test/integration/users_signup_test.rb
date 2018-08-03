require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:'',
                                email:'user@invalid',
                                password:'foo',
                                password_confirmation:'bar '} }
    end
    assert_template 'users/new'
  end

  test 'valid signup information with activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:'Example User',
                                email:'user@example.com',
                                password:'Foobar',
                                password_confirmation:'Foobar'}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user) #postアクション(create)で作ったインスタンス変数@userを参照。
    assert_not user.activated?
    #有効化前
    log_in_as(user)
    assert_not is_logged_in?
    #無効な有効化トークン
    get edit_account_activation_url('invalid token', email:user.email)
    assert_not is_logged_in?
    #トークンは正しいがemailが間違い
    get edit_account_activation_url(user.activation_token, email:'Wrong')
    assert_not is_logged_in?
    #正解
    get edit_account_activation_url(user.activation_token, email:user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
