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

    it "Must post a message to bot-traffic by default" do
       VCR.use_cassette("Slack API post message to bot-traffic") do
            # Arrange
            client = SlackApiOnTheKeep.new

            # Act
            client.postMessage(message: "Hello, #bot-traffic, from the Exploratory Tests!")

            # Assert
            # No SlackApiError thrown.
       end
    end

    it "Must post a message to the channel specified" do
        VCR.use_cassette("Slack API post message to everyone") do
             # Arrange
             client = SlackApiOnTheKeep.new
 
             # Act
             client.postMessage(channel: "everyone", message: "Hello, #everyone, from the Exploratory Tests!")
 
             # Assert
             # No SlackApiError thrown.
        end
    end
end
