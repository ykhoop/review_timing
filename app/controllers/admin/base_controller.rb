class Admin::BaseController < ApplicationController
  before_action :check_admin

  layout 'admin/layouts/application'

  private

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to admin_login_path
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end

  def log_exec_to_db
    id_case_not_login = 0

    user_id = current_user ? current_user.id : id_case_not_login
    log_level = :info
    program = "#{self.class.name}.#{action_name}"
    log_content = "user_id:#{user_id},msg_text:executed"
    Log.logger!(log_level, program, log_content)
  end
end
