class Admin::SystemReviewSettingsController < Admin::BaseController
  before_action :set_system_review_settings_menu_active, only: %i[index]

  def index
    @system_review_settings = SystemReviewSetting.all
  end

  def update_all
    upd_success, err_system_review_setting = update_system_review_settings
    if upd_success
      redirect_to admin_system_review_settings_path, success: t('.success')
    else
      @system_review_settings = []
      params[:system_review_setting].each do |id, system_review_setting_params|
        if id.to_i == err_system_review_setting.id
          @system_review_settings << err_system_review_setting
        else
          system_review_setting = SystemReviewSetting.new
          system_review_setting.id = id.to_i
          system_review_setting.review_number = system_review_setting_params[:review_number]
          system_review_setting.review_days = system_review_setting_params[:review_days]
          @system_review_settings << system_review_setting
        end
      end

      flash.now[:danger] = t('.fail')
      render :index, status: :unprocessable_entity
    end
  end

  private

  def update_system_review_settings
    err_system_review_setting = nil
    ActiveRecord::Base.transaction do
      params[:system_review_setting].each do |id, system_review_setting_params|
        system_review_setting = SystemReviewSetting.find(id)
        if !system_review_setting.update(system_review_setting_params.permit(:review_number, :review_days))
          err_system_review_setting = system_review_setting
          raise 'error'
        end
      end
    end
    return true, nil
  rescue StandardError
    return false, err_system_review_setting
  end

  def set_system_review_settings_menu_active
    @system_review_settings_menu_active = 'active'
  end
end
