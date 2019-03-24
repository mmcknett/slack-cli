require_relative './channel'

class Workspace
    def initialize(apiClient)
        @apiClient = apiClient
    end

    def channels
        allSlackChannels = @apiClient.listChannels
        return allSlackChannels.map{ |slackChannel| Channel.new(slackChannel) }
    end
end