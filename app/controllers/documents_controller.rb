class DocumentsController < ApplicationController
  skip_before_action :require_login, only: %i[terms privacy_policy]

  def terms
    @doc = Document.find_by(code: 'terms')
  end

  def privacy_policy
    @doc = Document.find_by(code: 'privacy_policy')
  end
end
