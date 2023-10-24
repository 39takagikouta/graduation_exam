class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:edit, :update, :destroy]

  include YoutubeApi

  def mypage
    Alarm.set_false_to_is_successful(current_user)
    @last_alarm = Alarm.where.not(is_successful: nil)
                  .where(user_id: current_user.id)
                  .order(wake_up_time: :desc)
                  .first
    @alarm = Alarm.find_by(user_id: current_user.id, wake_up_time: Date.today.beginning_of_day..Date.tomorrow.end_of_day, is_successful: nil)
    @alarms = Alarm.where(user_id: current_user.id)
  end

  def new
    @alarm = Alarm.new
    @alarm.wake_up_time = Time.now.tomorrow.beginning_of_day
  end

  def create
    @alarm = current_user.alarms.new(alarm_params)
    if @alarm.save
      redirect_to mypage_path, notice: 'アラームが正常に登録されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @alarm.update(alarm_params)
      redirect_to mypage_path, notice: 'アラームが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @alarm.destroy
    redirect_to mypage_path, notice: 'アラームが正常に削除されました。'
  end

  def recommend
    tags = current_user.comedy_tags.pluck(:name)
    keywords = current_user.keywords.pluck(:name)
    query_elements = []
    query_elements.concat(tags) if tags.present?
    query_elements.concat(keywords) if keywords.present?
    query = query_elements.join(" ")
    @search_results = find_videos(query)
    @item = @search_results.items.reject { |item| current_user.viewed_videos.pluck(:video_id).include?(item.id.video_id) }.first
    unless @item
      redirect_to mypage_path, alert: '申し訳ありません。設定していただいた検索ワードと動画の時間でレコメンドできる動画が無くなりました。検索ワードか時間、またはその両方を変更してください。'
      return
    end
  end

  private

  def set_alarm
    @alarm = current_user.alarms.find(params[:id])
  end

  def alarm_params
    params.require(:alarm).permit(:wake_up_time, :custom_video_url)
  end
end
