# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  # ユーザーの利用履歴用ヘルパー
  helper_method :user_last_login_at, :user_last_logout_at
  # セッションタイムアウト用ヘルパー
  helper_method :session_last_activity_at
  # アクセス履歴記録用ヘルパー
  helper_method :mealtask_create, :othertask_create, :tag_create, :comment_create, :memo_create
  # 現在記録中のアクセス履歴呼び出しメソッド
  helper_method :usage_histories
  # テストユーザーがログアウトする時にデフォルトのタグ・投稿以外を削除するメソッド
  helper_method :test_user_reset

  before_action :login_required
  before_action :time_out
  before_action :set_inquiry

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url, notice: "ログインしてください。" unless current_user
  end

  def forbid_login_user
    if session[:user_id]
      flash[:notice] = "すでにログインしています"
      redirect_to user_path(session[:user_id])
    end
  end

  def set_inquiry
    @inquiry = Inquiry.new
  end
  

  # 以下、Activity logging

  def user_last_login_at
    user = current_user
    # 最後にログインした日時の更新・ログイン回数追加
    user.update(last_login_at: Time.current)
    user.update(login_count: user.login_count + 1)
    # アクセス履歴のレコードを新規作成
    UsageHistory.create(
      user_id: user.id,
      login_at: Time.current
    )
  end

  def usage_histories
    usage_histories = UsageHistory.where(user_id: current_user.id).last
  end

  def user_last_logout_at
    user = current_user
    # 最後にログアウトした日時の更新
    user.update(last_logout_at: Time.current)
    # アクセス履歴のログアウト時刻を更新
    usage_histories.update(logout_at: Time.current)
    # アクセス履歴の利用時間を記録
    update_time = Time.current - usage_histories.login_at.to_time
    update_time = update_time.to_i
    usage_histories.update(utilization_time: Time.at(update_time).utc.strftime('%X'))
  end

  def session_last_activity_at
    # セッションタイムアウト用にページ遷移＝アクティヴィティとして時刻を記録
    session[:last_activity_at] = Time.current
  end

  def time_out
    if current_user
      if session[:last_activity_at].to_time.since(30.minutes) > Time.current
        session_last_activity_at if current_user
        # アクセス履歴のアクション回数とその日時を更新
        usage_histories.update(
          action_count: usage_histories.action_count + 1,
          last_activity_at: Time.current
        )
      else
        user_last_logout_at
        usage_histories.update(
          timeout: true,
          timeout_time: Time.current
        )
        test_user_reset
        reset_session
        flash[:notice] = "一定時間操作がなかったため、ログアウトしました。"
        redirect_to :login
      end
    end
  end

  def mealtask_create
    usage_histories.update(mealtask_create_count: usage_histories.mealtask_create_count + 1)
  end

  def othertask_create
    usage_histories.update(othertask_create_count: usage_histories.othertask_create_count + 1)
  end

  def tag_create
    usage_histories.update(tag_create_count: usage_histories.tag_create_count + 1)
  end

  def comment_create
    usage_histories.update(comment_create_count: usage_histories.comment_create_count + 1)
  end

  def memo_create
    usage_histories.update(memo_create_count: usage_histories.memo_create_count + 1)
  end

  def test_user_reset
    if current_user.id == 1
      current_user.task_tags.where(protected: false).destroy_all if current_user.task_tags.exists?
      current_user.meal_tasks.where(protected: false).destroy_all if current_user.meal_tasks.exists?
      current_user.user_memos.where(protected: false).destroy_all if current_user.user_memos.exists?
    end
  end
end
