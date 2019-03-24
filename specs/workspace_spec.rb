require_relative '../lib/workspace'

require_relative './test_helper'
require_relative './mocks/channel_response_mocks'

class MockApi
    attr_reader :listChannelsCalled, :listUsersCalled, :postMessageCalled

    def initialize
        @listChannelsCalled = @listUsersCalled = @postMessageCalled = false
    end

    def listChannels
        @listChannelsCalled = true

        # Return some fake channels with name, topic, member count, and Slack ID
        return [Mocks::CHANNEL_1, Mocks::CHANNEL_2]
    end

    def listUsers
        @listUsersCalled = true
    end

    def postMessage(message: "", channel: "")
        @postMessageCalled = true
    end
end

describe "Workspace" do
    it "must be able to be constructed with a mock API" do
        # Arrange/Act
        Workspace.new(MockApi.new)

        # Assert
        # No errors raised.
    end

    it "must return channels with the expected transform" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        channels = workspace.channels

        # Assert
        expect(channels).must_equal [Channel.new(Mocks::CHANNEL_1), Channel.new(Mocks::CHANNEL_2)]
    end
end