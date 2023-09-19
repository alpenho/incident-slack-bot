module RootliesHelper
  PARAMETER_INCIDENT_REGEX = /<(.*?)>/

  def declare!(user_id, text_param)
    incident_params = text_param.scan(PARAMETER_INCIDENT_REGEX).flatten

    ::Incident.new(
      title: incident_params[0],
      description: incident_params[1],
      severity: incident_params[2]
    ).save!

    ::SlackApi::Client.new.create_channel(user_id, "incident-#{incident_params[0]}")
  rescue => e
    puts e
    raise "There is an error when declaring incident"
  end

  def resolve!
  end
end