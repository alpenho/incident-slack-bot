require 'slack-ruby-block-kit'

module SlackModalHelper
  TITLE_BLOCK_INPUT = 'title_block_input'
  TITLE_INPUT = 'title_input'
  SEVERITY_BLOCK_INPUT = 'severity_block_input'
  SEVERITY_INPUT = 'severity_input'
  DESCRIPTION_BLOCK_INPUT = 'description_block_input'
  DESCRIPTION_INPUT = 'description_input'

  def show_modal_declare(trigger_id)
    blocks = Slack::BlockKit.blocks do |b|
      b.section do |s|
        s.mrkdwn(text: 'Hello, With this form you can create a new incident and then it will automatically create a new channel.\n\n *Please put the detail of the incident:*')
      end

      b.divider

      b.input(label: 'Title', block_id: TITLE_BLOCK_INPUT) do |i|
        i.plain_text_input(
          action_id: 'title_input',
          placeholder: 'Write incident title'
        )
      end

      b.input(label: 'Severity', block_id: SEVERITY_BLOCK_INPUT) do |i|
        i.static_select(
          action_id: 'severity_input',
          placeholder: 'Select severity'
        ) do |s|
          s.option(value: 'sev0', text: 'severity 0')
          s.option(value: 'sev1', text: 'severity 1')
          s.option(value: 'sev2', text: 'severity 2')
        end
      end

      b.input(label: 'Description', block_id: DESCRIPTION_BLOCK_INPUT) do |i|
        i.plain_text_input(
          action_id: DESCRIPTION_INPUT,
          placeholder: 'Describe the detail of incident',
          multiline: true
        )
      end
    end

    modal = Slack::Surfaces::Modal.new(blocks: blocks, callback_id: 'declare-modal-form')
    modal.title(text: 'Creating an Incident!')
    modal.submit(text: 'Create')
    modal.close(text: 'Close')

    url = 'https://slack.com/api/views.open'
    body = {
      trigger_id: trigger_id,
      view: modal.as_json
    }

    response = Faraday.post(
      url,
      body.to_json,
      'Content-Type' => 'application/json'
    ) do |request|
      request.headers["Authorization"] = "Bearer #{ENV['SLACK_OAUTH_TOKEN']}"
    end
  end

  def create_incident!(user_id, values)
    incident = ::Incident.new(
      title: values[TITLE_BLOCK_INPUT][TITLE_INPUT]['value'],
      severity: values[SEVERITY_BLOCK_INPUT][SEVERITY_INPUT]['value'],
      description: values[DESCRIPTION_BLOCK_INPUT][DESCRIPTION_INPUT]['value'],
      slack_channel_id: 'channel_id_placeholder'
    )
    incident.save!
    ::CreateSlackChannelJob.perform_later(user_id, incident.id, incident.title.gsub(' ', '-').downcase)
  rescue => e
    puts e
    raise "There is an error when declaring incident"
  end
end
