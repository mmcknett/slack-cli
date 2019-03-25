require_relative './channel'
require_relative './user'

class Workspace
    attr_reader :selected

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

    def select_channel(nameOrId)
        select_recipient nameOrId, channels
    end

    private def select_recipient(nameOrId, recipientList)
        recipientIdx = recipientList.index { |recipient|
            recipient.name == nameOrId || recipient.slack_id == nameOrId
        }
        @selected = recipientIdx == nil ? nil : recipientList[recipientIdx]
    end
end