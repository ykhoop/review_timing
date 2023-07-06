class AuthenticationsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    sorcery_fetch_user_hash(provider)
    uid = @user_hash[:uid]

    authentication = Authentication.find_by(user_id: current_user.id,  provider: provider)
    if (authentication)
      authentication.update!(uid: uid)
    else
      Authentication.create!(
                              user_id: current_user.id,
                              provider: provider,
                              uid: uid,
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

  def auth_params
    params.permit(:code, :provider, :error, :state, :email)
  end
end
