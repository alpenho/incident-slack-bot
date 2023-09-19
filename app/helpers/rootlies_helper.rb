module RootliesHelper
  PARAMETER_INCIDENT_REGEX = /<(.*?)>/

  def declare!(text_param)
    incident_params = text_param.scan(PARAMETER_INCIDENT_REGEX).flatten

    ::Incident.new(
      title: incident_params[0],
      description: incident_params[1],
      severity: incident_params[2]
    ).save!
  end

  def resolve!
  end
end