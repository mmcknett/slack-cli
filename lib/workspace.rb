require_relative './channel'
require_relative './user'

class Workspace
    def initialize(apiClient)
        @apiClient = apiClient
    end

    def channels
        allSlackChannels = @apiClient.listChannels
        return allSlackChannels.map{ |slackChannel| Channel.new(slackChannel) }
    end

    def users
        allUsers = @apiClient.listUsers
        return allUsers.map{ |slackUser| User.new(slackUser) }
    end
end