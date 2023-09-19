class RootliesController < ApplicationController
  skip_before_action :verify_authenticity_token

  PARAMETER_INCIDENT_REGEX = /<(.*?)>/

  # POST /rootly
  def rootly
    payload = {
      text: 'success'
    }
    check_token_slack!
    incident_parameters = get_params
    payload[:text] = "title #{incident_parameters[0]}, description #{incident_parameters[1]}, severity #{incident_parameters[2]}"
    render json: payload, status: 200
  rescue => e
    payload[:text] = e.message
    render json: payload, status: 200
  end

  private

  def check_token_slack!
    raise 'the application is not authorized!' unless request.params['token'] == ENV['SLACK_TOKEN']
  end

  def get_params
    request.params['text'].scan(PARAMETER_INCIDENT_REGEX).flatten
  end
end