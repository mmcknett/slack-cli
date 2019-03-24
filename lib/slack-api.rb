require 'dotenv'
require 'httparty'

Dotenv.load
$slackSecret = ENV['SLACK_SECRET']

# Note: The internet says to make custom errors inherit from StandardError.
# See: https://www.honeybadger.io/blog/ruby-exception-vs-standarderror-whats-the-difference/
class SlackApiError < StandardError
end

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
        # For this assignment, I'm ignoring additional pages.
        return channelResp["channels"]
    end

    def listUsers
        usersResp = self.class.get("/users.list", @argsForEachReq)
        # For this assignment, I'm ignoring additional pages.
        return usersResp["members"]
    end

    def postMessage(message: "", channel: "bot-traffic")
        args = @argsForEachReq.merge({
            body: {
                channel: channel,
                text: message
            }
        })
        postMessageResp = self.class.post("/chat.postMessage", args)

        unless postMessageResp["ok"]
            raise SlackApiError, "Unable to post message. Error: #{postMessageResp["error"]}"
        end
    end
end
