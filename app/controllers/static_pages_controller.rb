class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
  end

  def logged_in_top
  end
end
