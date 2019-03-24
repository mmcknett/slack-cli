require_relative '../lib/channel'

require_relative './mocks/channel_response_mocks'
require_relative './test_helper'

describe "Channel class" do
    it "throws ArgumentError if no topic is provided" do
        # Arrange
        mockSlackResponse = {}.merge(Mocks::CHANNEL_1)
        mockSlackResponse.delete("topic")

        # Act/Assert
        expect { Channel.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "throws ArgumentError if no membership count is provided" do
        # Arrange
        mockSlackResponse = {}.merge(Mocks::CHANNEL_1)
        mockSlackResponse.delete("num_members")

        # Act/Assert
        expect { Channel.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "has a topic and membership count" do
        # Arrange
        mockSlackResponse = Mocks::CHANNEL_1

        # Act
        channel = Channel.new(mockSlackResponse)

        # Assert
        expect(channel.slack_id).must_equal Mocks::CHANNEL_1["id"]
        expect(channel.name).must_equal Mocks::CHANNEL_1["name"]
        expect(channel.member_count).must_equal Mocks::CHANNEL_1["num_members"]
        expect(channel.topic).must_equal Mocks::CHANNEL_1["topic"]["value"]
    end
end