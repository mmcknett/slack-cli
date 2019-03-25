require_relative '../lib/workspace'

require_relative './test_helper'
require_relative './mocks/channel_response_mocks'
require_relative './mocks/user_response_mocks'

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

        # Return some fake users
        return [Mocks::USER_1, Mocks::USER_2]
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

    it "must return users with the expected transform" do
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
end