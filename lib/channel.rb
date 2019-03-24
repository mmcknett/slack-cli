require_relative './recipient'

class Channel < Recipient
    attr_reader :topic, :member_count

    def initialize(slack_response)
        super(slack_response)

        raise ArgumentError, 'Missing argument slack_response["topic"]' if !slack_response.has_key?("topic") || !slack_response["topic"].has_key?("value")
        raise ArgumentError, 'Missing argument slack_response["num_members"]' if !slack_response.has_key?("num_members")

        @topic = slack_response["topic"]["value"]
        @member_count = slack_response["num_members"]
    end
end