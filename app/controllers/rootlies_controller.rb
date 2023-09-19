class RootliesController < ApplicationController
  include RootliesHelper

  skip_before_action :verify_authenticity_token

  DECLARE_REGEX = /^declare(\s+|)/
  RESOLVE_REGEX = /^resolve(\s+|)/

  # POST /rootly
  def rootly
    payload = {
      text: 'success'
    }
    check_token_slack!

    text_param = request.params['text']
    if is_declare?(text_param)
      declare!(request.params['user_id'], text_param)
    elsif is_resolve?(text_param)
      resolve!(request.params['channel_id'])
    else
      raise 'Wrong command or wrong format'
    end
    render json: payload, status: 200
  rescue => e
    payload[:text] = e.message
    render json: payload, status: 200
  end

  private

  def check_token_slack!
    raise 'the application is not authorized!' unless request.params['token'] == ENV['SLACK_TOKEN']
  end

  def is_declare?(text_param)
    text_param.match(DECLARE_REGEX).present?
  end

  def is_resolve?(text_param)
    text_param.match(RESOLVE_REGEX).present?
  end
end