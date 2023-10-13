class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
    @doc = Document.find_by(code: 'top_explanation')
  end
end
