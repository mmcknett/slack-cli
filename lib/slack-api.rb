require 'dotenv'
require 'httparty'

Dotenv.load
$slackSecret = ENV['SLACK_SECRET']

class SlackApiOnTheKeep
    include HTTParty
    base_uri "https://slack.com/api"

    def initialize
        @argsForEachReq = {
            headers: {
                "Authorization" => "Bearer #{$slackSecret}"
            }
        }
    end

    def listChannels
        channelResp = self.class.get("/channels.list", @argsForEachReq)
        # For this assignment, we're ignoring additional pages.
        return channelResp["channels"]
    end
end
