class ReviewScheduleController < ApplicationController
  def schedule
    # DBのタイムゾーン
    time_zone_of_db = 'UTC'
    # 表示するタイムゾーン
    time_zone_to_display = 'Tokyo'
    # パラメータから年月を取得
    str_ym = params[:ym]

    # 日付関係の変数を設定
    date_ymd = Time.zone.parse(str_ym + '01')
    @this_y = date_ymd.year
    @this_m = date_ymd.month
    @this_end_day = date_ymd.end_of_month.day
    @prev_ym = date_ymd.prev_month.strftime('%Y%m')
    @next_ym = date_ymd.next_month.strftime('%Y%m')

    # 対象月のレコードを取得するための日付条件を設定
    start_date = date_ymd.beginning_of_month.in_time_zone(time_zone_of_db)
    next_start_date = date_ymd.next_month.beginning_of_month.in_time_zone(time_zone_of_db)

    # ユーザーのスケジュールのレコードを取得
    user_schedules_records = current_user.subjects.joins(subject_details: :subject_reviews)
                                          .where(subject_reviews: { review_type: 0 })
                                          .where('(subject_details.start_at >= ? AND subject_details.start_at < ?)
                                                  OR (subject_reviews.review_at >= ? AND subject_reviews.review_at < ?)',
                                                  start_date, next_start_date, start_date, next_start_date
                                                )
                                          .order('subjects.id
                                                  , subject_details.id
                                                  , subject_reviews.review_number'
                                                )
                                          .select('subjects.id as subject_id
                                                  , subjects.title
                                                  , subject_details.id as subject_detail_id
                                                  , subject_details.chapter
                                                  , subject_details.start_page
                                                  , subject_details.end_page
                                                  , subject_details.start_at
                                                  , subject_reviews.id as subject_review_id
                                                  , subject_reviews.review_number
                                                  , subject_reviews.review_at'
                                          )

    # 変数初期化
    pre_subject_detail_id = 0
    user_schedule = {}
    @user_schedules = []

    # 取得したレコードを整形
    user_schedules_records.each do |redcord|

      # 科目詳細ごとにハッシュを作成
      if redcord.subject_detail_id != pre_subject_detail_id then

        if pre_subject_detail_id != 0 then
          @user_schedules.push user_schedule
        end

        user_schedule = {}
        user_schedule['title'] = redcord.title
        user_schedule['chapter'] = redcord.chapter
        user_schedule['start_page'] = redcord.start_page
        user_schedule['end_page'] = redcord.end_page
        user_schedule['start_at'] = redcord.start_at
        user_schedule['review_number'] = redcord.review_number
        user_schedule['review_at'] = redcord.review_at
        @this_end_day.times do |i|
          user_schedule[i + 1] = ''
        end
      end

      # 学習開始日時が対象月の場合はSを設定
      if redcord.start_at.in_time_zone(time_zone_to_display).month == @this_m then
        if redcord.review_number == 1 then
          user_schedule[redcord.start_at.in_time_zone(time_zone_to_display).day] = 'S '
        end
      end

      # レビュー日時が対象月の場合はRを設定
      if redcord.review_at.in_time_zone(time_zone_to_display).month == @this_m then
        user_schedule[redcord.review_at.in_time_zone(time_zone_to_display).day] << "R#{redcord.review_number} "
      end

      # 科目詳細IDを格納しておく
      pre_subject_detail_id = redcord.subject_detail_id
    end

    if user_schedule.empty? == false then
      @user_schedules.push user_schedule
    end

    @user_schedules = Kaminari.paginate_array(@user_schedules).page(params[:page])
  end
end
