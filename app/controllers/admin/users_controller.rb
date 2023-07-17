class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_users_menu_active, only: %i[index show edit]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(:id).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, success: t('.success', item: @user.id)
    else
      flash.now[:danger] = t('.fail', item: @user.id)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, success: t('.success', item: @user.email)
  end


  private

  def set_users_menu_active
    @users_menu_active = 'active'
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :role,
    )
  end
end
