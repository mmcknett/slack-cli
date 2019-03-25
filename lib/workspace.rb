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

    def select_user(nameOrId)
        select_recipient nameOrId, users
    end

    private def select_recipient(nameOrId, recipientList)
        recipientIdx = recipientList.index { |recipient|
            recipient.name == nameOrId || recipient.slack_id == nameOrId
        }
        raise ArgumentError, "Recipient with name/id #{nameOrId} could not be found." if recipientIdx == nil
        @selected = recipientList[recipientIdx]
    end

    def send_message(message)
        raise RuntimeError, "No recipient is selected" if @selected.nil?
        @apiClient.postMessage(message: message, channel: @selected.slack_id)
    end
end