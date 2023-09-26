class RootliesController < ApplicationController
  include RootliesHelper
  include SlackModalHelper

  skip_before_action :verify_authenticity_token

  DECLARE_REGEX = /^declare(\s+|)/
  RESOLVE_REGEX = /^resolve(\s+|)/
  DECLARE = 'declare'

  # POST /rootly
  def rootly
    payload = { text: '' }
    check_token_slack!

    text_param = request.params['text']
    if is_declare?(text_param)
      declare!(request.params['user_id'], text_param)
      payload[:text] = 'Incident data is already being added, please wait for the channel creation'
    elsif is_resolve?(text_param)
      incident = resolve!(request.params['channel_id'])
      payload[:text] = "Incident is already flagged as resolved, it takes #{time_difference_in_string(incident.created_at, incident.resolved_at)}"
    else
      payload[:text] = 'Wrong command or wrong format'
    end
    render json: payload, status: 200
  rescue => e
    payload[:text] = e.message
    render json: payload, status: 200
  end

  def rootly_interactive
    payload = JSON.parse(request.params['payload'])
    if payload['type'] == 'shortcut' && payload['callback_id'] == DECLARE
      show_modal_declare(payload['trigger_id'])
    elsif payload['type'] == 'view_submission' && payload['view']['callback_id'] == 'declare-modal-form'
      create_incident!(payload['user']['id'], payload['view']['state']['values'])
    end
    render json: {}, status: 200
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