class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]
  after_action :log_exec_to_db, only: %i[create destroy]

  layout 'layouts/admin_login'

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to admin_dashboards_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to admin_login_path, success: t('.success')
  end
end
