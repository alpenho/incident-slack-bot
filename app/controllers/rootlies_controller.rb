class RootliesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /rootly
  def rootly
    payload = {
      text: 'success'
    }
    check_token_slack!
    render json: payload, status: 200
  rescue => e
    payload[:text] = e.message
    render json: payload, status: 200
  end

  private

  def check_token_slack!
    raise 'the application is not authorized!' unless request.params['token'] == ENV['SLACK_TOKEN']
  end
end