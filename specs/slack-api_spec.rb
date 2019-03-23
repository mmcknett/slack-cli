require_relative 'test_helper'
require_relative '../lib/slack-api'

describe "Exploratory tests for the live slack API" do
    it "Must return a channel list that contains \"#bot-traffic\"" do
        VCR.use_cassette("Slack API list channels check #bot-traffic") do
            # Arrange
            client = SlackApiOnTheKeep.new

            # Act
            channels = client.listChannels

            # Assert
            expect(channels.length).must_be :>, 0
            expect(channels.any? {|channel| channel["name"] == "bot-traffic"})
        end
    end

    it "Must return a user list that contains @Slackbot" do
        VCR.use_cassette("Slack API list users check for Slackbot") do
            # Arrange
            client = SlackApiOnTheKeep.new

            # Act
            users = client.listUsers

            # Assert
            expect(users.length).must_be :>, 0
            expect(users.any? {|user| user["name"] == "slackbot"})
        end
    end
end
