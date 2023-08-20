class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
    @doc_ex = Document.find_by(code: 'top_explanation')
    @doc_pr = Document.find_by(code: 'top_process')
  end
end
