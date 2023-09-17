json.extract! incident, :id, :title, :description, :severity, :created_at, :updated_at
json.url incident_url(incident, format: :json)
