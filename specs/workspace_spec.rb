require_relative '../lib/workspace'

require_relative './test_helper'
require_relative './mocks/channel_response_mocks'
require_relative './mocks/user_response_mocks'

class MockApi
    attr_reader :postMessageCalled, :postedMessage, :channelPostedTo

    def initialize
        @listChannelsCalled = @listUsersCalled = @postMessageCalled = false
    end

    def listChannels
        # Return some fake channels with name, topic, member count, and Slack ID
        return [Mocks::CHANNEL_1, Mocks::CHANNEL_2]
    end

    def listUsers
        # Return some fake users
        return [Mocks::USER_1, Mocks::USER_2]
    end

    def postMessage(message: "", channel: "")
        @postMessageCalled = true
        @postedMessage = message
        @channelPostedTo = channel
    end
end

describe "Workspace" do
    it "must be able to be constructed with a mock API" do
        # Arrange/Act
        Workspace.new(MockApi.new)

        # Assert
        # No errors raised.
    end

    it "must return channels based on the Slack API data" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        channels = workspace.channels

        # Assert
        expect(channels).must_equal [Channel.new(Mocks::CHANNEL_1), Channel.new(Mocks::CHANNEL_2)]
    end

    it "must return users based on the Slack API data" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        users = workspace.users

        # Assert
        expect(users).must_equal [User.new(Mocks::USER_1), User.new(Mocks::USER_2)]
    end

    it "must have nothing selected initially" do
        # Arrange/Act
        workspace = Workspace.new(MockApi.new)

        # Assert
        expect(workspace.selected).must_be_nil
    end

    it "must allow selecting a channel by name" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        workspace.select_channel Mocks::CHANNEL_1["name"]

        # Assert
        expect(workspace.selected).must_equal Channel.new(Mocks::CHANNEL_1)
    end

    it "must allow selecting a channel by id" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        workspace.select_channel Mocks::CHANNEL_1["id"]

        # Assert
        expect(workspace.selected).must_equal Channel.new(Mocks::CHANNEL_1)
    end

    it "must raise ArgumentError if the channel/id is invalid" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act/Assert
        expect {
            workspace.select_channel "invalid_id"
        }.must_raise ArgumentError
    end

    it "must allow selecting a user by name" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        workspace.select_user Mocks::USER_1["name"]

        # Assert
        expect(workspace.selected).must_equal User.new(Mocks::USER_1)
    end

    it "must allow selecting a user by id" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act
        workspace.select_user Mocks::USER_1["id"]

        # Assert
        expect(workspace.selected).must_equal User.new(Mocks::USER_1)
    end

    it "must raise ArgumentError if the name/id is invalid" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act/Assert
        expect {
            workspace.select_user "invalid_id"
        }.must_raise ArgumentError
    end

    it "must raise RuntimeError if no recipient is selected for send_message" do
        # Arrange
        workspace = Workspace.new(MockApi.new)

        # Act/Assert
        expect {
            workspace.send_message "Hello from the Workspace tests!"
        }.must_raise RuntimeError
    end

    it "must send a message to the selected channel via the api" do
        # Arrange
        api = MockApi.new
        workspace = Workspace.new(api)
        channel = Channel.new(Mocks::CHANNEL_1)
        workspace.select_channel channel.slack_id
        message = "Hello from the Workspace tests!"

        # Act
        workspace.send_message message

        # Act/Assert
        expect(api.postMessageCalled).must_equal true
        expect(api.postedMessage).must_equal message
        expect(api.channelPostedTo).must_equal channel.slack_id
    end
end