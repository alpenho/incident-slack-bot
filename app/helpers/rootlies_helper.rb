module RootliesHelper
  PARAMETER_INCIDENT_REGEX = /<(.*?)>/

  def declare!(user_id, text_param)
    incident_params = text_param.scan(PARAMETER_INCIDENT_REGEX).flatten

    incident = ::Incident.new(
      title: incident_params[0],
      description: incident_params[1],
      severity: incident_params[2],
      slack_channel_id: 'channel_id_placeholder'
    )
    incident.save!
    ::CreateSlackChannelJob.perform_later(user_id, incident.id, incident.title)
  rescue => e
    puts e
    raise "There is an error when declaring incident"
  end

  def resolve!(channel_id)
    # assume 1 channel for 1 incident that still active
    incident = Incident.in_progress.where(slack_channel_id: channel_id).first
    raise "This channel is not related to any of the incidents that still active" if incident.nil?

    incident.update!(state: 'resolved', resolved_at: Time.now)
  end
end