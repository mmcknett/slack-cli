require_relative 'test_helper'
require_relative '../lib/slack-api'

describe "Exploratory tests for the live slack API" do
    it "Must return a channel list that contains \"everyone\"" do
        VCR.use_cassette("Slack API list channels check #everyone") do
            # Arrange
            client = SlackApiOnTheKeep.new

            # Act
            channels = client.listChannels

            # Assert
            expect(channels.length).must_be :>, 0
            expect(channels.any? {|channel| channel["name"] == "everyone"})
        end
    end
end
