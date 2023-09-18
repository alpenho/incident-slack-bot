class RootliesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /rootly
  def rootly
    render json: { text: 'success' }
  end
end