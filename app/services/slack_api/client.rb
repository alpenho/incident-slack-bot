module SlackApi
  class Client
    attr_reader :client

    def initialize
      @client = Slack::Web::Client.new
      @client.auth_test
    end

    # Will create the channel and then add the user that declare the incident
    def create_channel(user_id, channel_name, is_private=nil, team_id=nil)
      response = @client.conversations_create(name: channel_name, is_private: is_private, team_id: team_id)
      @client.conversations_invite(channel: response['channel']['id'], users: user_id)
    end
  end
end