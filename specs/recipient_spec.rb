require_relative './test_helper'

require_relative '../lib/recipient'

describe "Recipient class" do
    it "throws ArgumentError if no parameter is provided" do
        # Arrange
        mockSlackResponse = nil

        # Act/Assert
        expect { Recipient.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "throws ArgumentError if no name is provided" do
        # Arrange
        mockSlackResponse = { "id" => "ABC123456" }

        # Act/Assert
        expect { Recipient.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "throws ArgumentError if no id is provided" do
        # Arrange
        mockSlackResponse = { "name" => "recipient name" }

        # Act/Assert
        expect { Recipient.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "has a name and slack_id" do
        # Arrange
        name = "recipient name"
        id = "ABC123456"
        mockSlackResponse = { "name" => name, "id" => id }

        # Act
        recipient = Recipient.new(mockSlackResponse)

        # Assert
        expect(recipient.slack_id).must_equal id
        expect(recipient.name).must_equal name
    end

    it "compares identical recipients as equal" do
        # Arrange
        mockSlackResponse = { "name" => "recipient name", "id" => "ABC123456" }

        # Act/Assert
        expect(Recipient.new(mockSlackResponse)).must_equal Recipient.new(mockSlackResponse)
    end
end