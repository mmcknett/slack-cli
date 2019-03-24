class Recipient
    attr_reader :slack_id, :name

    def initialize(slack_response)
        raise ArgumentError, 'Missing argument slack_response' if slack_response == nil
        raise ArgumentError, 'Missing argument slack_response["name"]' if !slack_response.has_key?("name")
        raise ArgumentError, 'Missing argument slack_response["id"]' if !slack_response.has_key?("id")
    
        @slack_id = slack_response["id"]
        @name = slack_response["name"]
    end

    def ==(other)
        self.slack_id == other.slack_id &&
        self.name == other.name
    end
end