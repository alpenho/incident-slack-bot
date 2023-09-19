class CreateSlackChannelJob < ApplicationJob
  queue_as :default

  def perform(user_id, incident_id, incident_title)
    channel_id = ::SlackApi::Client.new.create_channel(user_id, "incident-#{incident_title}")
    incident = Incident.find(incident_id)
    incident.slack_channel_id = channel_id
    incident.save!
  end
end
