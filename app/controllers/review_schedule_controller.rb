class ReviewScheduleController < ApplicationController
  TIME_ZONE_TO_DISPLAY = Rails.application.config.time_zone
  TIME_ZONE_OF_DB = 'UTC'

  def schedule
    ym = params[:ym]
    ymd = Time.zone.parse(ym + '01')
    @curt_y = ymd.year
    @curt_m = ymd.month
    @curt_ym_end_day = ymd.end_of_month.day
    @prev_ym = ymd.prev_month.strftime('%Y%m')
    @next_ym = ymd.next_month.strftime('%Y%m')

    start_date = ymd.beginning_of_month
    next_start_date = ymd.next_month.beginning_of_month
    db_start_date = start_date.in_time_zone(TIME_ZONE_OF_DB)
    db_next_start_date = next_start_date.in_time_zone(TIME_ZONE_OF_DB)
    user_schedules_records = current_user.subjects.joins(subject_details: :subject_reviews)
                                         .where(subject_reviews: { review_type: 0 })
                                         .where('(subject_details.start_at >= ? AND subject_details.start_at < ?)
                                                  OR (subject_reviews.review_at >= ? AND subject_reviews.review_at < ?)',
                                                  db_start_date, db_next_start_date, db_start_date, db_next_start_date)
                                         .order('subjects.id
                                                  , subject_details.id
                                                  , subject_reviews.review_number')
                                         .select('subjects.id as subject_id
                                                  , subjects.title
                                                  , subject_details.id as subject_detail_id
                                                  , subject_details.chapter
                                                  , subject_details.start_page
                                                  , subject_details.end_page
                                                  , subject_details.start_at
                                                  , subject_reviews.id as subject_review_id
                                                  , subject_reviews.review_number
                                                  , subject_reviews.review_at')

    pre_subject_detail_id = 0
    user_schedule = {}
    @user_schedules = []

    user_schedules_records.each do |redcord|
      # 科目詳細ごとにハッシュを作成
      if redcord.subject_detail_id != pre_subject_detail_id
        @user_schedules.push user_schedule if pre_subject_detail_id != 0
        user_schedule = {}
        user_schedule['title'] = redcord.title
        user_schedule['chapter'] = redcord.chapter
        user_schedule['start_page'] = redcord.start_page
        user_schedule['end_page'] = redcord.end_page
        user_schedule['start_at'] = redcord.start_at
        user_schedule['review_number'] = redcord.review_number
        user_schedule['review_at'] = redcord.review_at
        # １ヶ月の日数分の配列を作成
        @curt_ym_end_day.times do |i|
          user_schedule[i + 1] = ''
        end
      end

      # 学習開始日時が対象月の場合はSを設定（複数の'S'が設定されないように１回のみ設定）
      if redcord.start_at.in_time_zone(TIME_ZONE_TO_DISPLAY).month == @curt_m && (redcord.review_number == 1)
        user_schedule[redcord.start_at.in_time_zone(TIME_ZONE_TO_DISPLAY).day] = 'S '
      end

      # レビュー日時が対象月の場合はRを設定
      if !redcord.review_at.nil? && (redcord.review_at.in_time_zone(TIME_ZONE_TO_DISPLAY).month == @curt_m)
        user_schedule[redcord.review_at.in_time_zone(TIME_ZONE_TO_DISPLAY).day] << "R#{redcord.review_number} "
      end

      # 科目詳細IDを格納しておく
      pre_subject_detail_id = redcord.subject_detail_id
    end
    @user_schedules.push user_schedule if user_schedule.empty? == false

    @user_schedules = Kaminari.paginate_array(@user_schedules).page(params[:page])
  end
end
