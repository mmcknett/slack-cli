require_relative '../lib/user'

require_relative './mocks/user_response_mocks'
require_relative './test_helper'

describe "User class" do
    it "throws ArgumentError if no real_name is provided" do
        # Arrange
        mockSlackResponse = {}.merge(Mocks::USER_1)
        mockSlackResponse.delete("real_name")

        # Act/Assert
        expect { User.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "throws ArgumentError if no profile.status_text is provided" do
        # Arrange
        mockSlackResponse = {}.merge(Mocks::USER_1)
        mockProfile = {}.merge(mockSlackResponse["profile"])
        mockProfile.delete("status_text")
        mockSlackResponse["profile"] = mockProfile

        # Act/Assert
        expect { User.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "throws ArgumentError if no profile.status_emoji is provided" do
        # Arrange
        mockSlackResponse = {}.merge(Mocks::USER_1)
        mockProfile = {}.merge(mockSlackResponse["profile"])
        mockProfile.delete("status_emoji")
        mockSlackResponse["profile"] = mockProfile

        # Act/Assert
        expect { User.new(mockSlackResponse) }.must_raise ArgumentError
    end

    it "has a real_name, status_text, and status_emoji" do
        # Arrange
        mockSlackResponse = Mocks::USER_1

        # Act
        recipient = User.new(mockSlackResponse)

        # Assert
        expect(recipient.slack_id).must_equal Mocks::USER_1["id"]
        expect(recipient.name).must_equal Mocks::USER_1["name"]
        expect(recipient.real_name).must_equal Mocks::USER_1["real_name"]
        expect(recipient.status_text).must_equal Mocks::USER_1["profile"]["status_text"]
        expect(recipient.status_emoji).must_equal Mocks::USER_1["profile"]["status_emoji"]
    end

    it "compares identical recipients as equal" do
        # Arrange
        mockSlackResponse = Mocks::USER_1

        # Act/Assert
        expect(User.new(mockSlackResponse)).must_equal User.new(mockSlackResponse)
    end
end