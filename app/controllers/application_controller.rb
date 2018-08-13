class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    render html: 'Hello, world!'
  end

  private

    #ユーザーのログインを確認
    #ログインしていなければurlを保存してフレンドリーフォワーディングの準備をする
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end
end
