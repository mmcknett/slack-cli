require_relative './recipient'

class User < Recipient
    attr_reader :real_name, :status_text, :status_emoji

    def initialize(slack_response)
        super(slack_response)

        raise ArgumentError, 'Missing argument slack_response["real_name"]' if !slack_response.has_key?("real_name")
        raise ArgumentError, 'Missing argument slack_response["profile"]["status_text"]' if !slack_response.has_key?("profile") || !slack_response["profile"].has_key?("status_text")
        raise ArgumentError, 'Missing argument slack_response["profile"]["status_emoji"]' if !slack_response.has_key?("profile") || !slack_response["profile"].has_key?("status_emoji")

        @real_name = slack_response["real_name"]
        @status_text = slack_response["profile"]["status_text"]
        @status_emoji = slack_response["profile"]["status_emoji"]
    end

    def ==(other)
        @slack_id == other.slack_id &&
        @name == other.name &&
        @real_name == other.real_name &&
        @status_text == other.status_text &&
        @status_emoji == other.status_emoji
    end

    def details
        return "#{@real_name} - #{@name} (#{@slack_id})\n  Current status: #{@status_emoji} #{@status_text}"
    end
end