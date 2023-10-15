class Admin::DashboardsController < Admin::BaseController
  before_action :set_dashboards_menu_active, only: %i[index]
  after_action :log_exec_to_db, only: %i[index]

  def index
    @user_cnt = User.count
    @subject_cnt = Subject.count
    @subject_detail_cnt = SubjectDetail.count

    @date_cond = Time.zone.today.last_month
    @each_day_user_reg_cnts = User.select("DATE(ADDTIME(created_at, '09:00:00')) as each_day, count(*) as cnt").group('each_day').having(
      'each_day >= ?', @date_cond
    ).order('each_day desc')
    @each_day_subject_reg_cnts = Subject.select("DATE(ADDTIME(created_at, '09:00:00')) as each_day, count(*) as cnt").group('each_day').having(
      'each_day >= ?', @date_cond
    ).order('each_day desc')
    @each_day_subject_detail_reg_cnts = SubjectDetail.select("DATE(ADDTIME(created_at, '09:00:00')) as each_day, count(*) as cnt").group('each_day').having(
      'each_day >= ?', @date_cond
    ).order('each_day desc')
  end

  private

  def set_dashboards_menu_active
    @dashboards_menu_active = 'active'
  end
end
