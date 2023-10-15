class AuthenticationsController < ApplicationController
  before_action :check_provider, only: %i[oauth callback destroy]

  def oauth
    login_at(auth_params[:provider])
    session[:provider_state] = @provider.state
  end

  def callback
    provider_state = session[:provider_state]
    res_error = auth_params[:error]
    res_state = auth_params[:state]
    res_provider = auth_params[:provider]

    unless res_error.blank?
      redirect_to root_path, danger: t('defaults.message.fail_line_linking')
      return
    end

    unless res_state == provider_state
      redirect_to root_path, danger: t('defaults.message.fail_line_linking')
      return
    end

    sorcery_fetch_user_hash(res_provider)
    uid = @user_hash[:uid]

    authentication = Authentication.find_by(user_id: current_user.id,  provider: res_provider)
    if (authentication)
      authentication.update!(uid: uid)
    else
      Authentication.create!(
                              user_id: current_user.id,
                              provider: res_provider,
                              uid:
                            )
    end
    redirect_to root_path
  end

  def destroy
    authentication = Authentication.find_by(user_id: current_user.id,  provider: auth_params[:provider])
    authentication.destroy!
    redirect_to root_path
  end

  private

  def check_provider
    unless %i[line].include?(auth_params[:provider].to_sym)
      logout
      redirect_to(login_path, warning: t('defaults.message.force_logout'))
    end
  end

  def auth_params
    params.permit(:_method, :code, :provider, :error, :state)
  end
end