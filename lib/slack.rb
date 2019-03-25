#!/usr/bin/env ruby
require 'table_print'

require_relative './slack-api'
require_relative './workspace'

$slackApi = SlackApiOnTheKeep.new
$workspace = Workspace.new($slackApi)

def main
  puts "Welcome to the Ada Slack CLI!"

  command = :showCommands
  until command == :exit
    command = prnt(execute(read(command)))
  end

  puts "Thank you for using the Ada Slack CLI! 💖"
end

def read(command)
  if command == :askInput
    puts ""
    puts "Enter command: "
    input = gets.chomp
    puts ""

    case input
    when "help"
      return :showCommands
    when "list users"
      return :listUsers
    when "list channels"
      return :listChannels
    when "select user"
      return askForUserToSelect
    when "select channel"
      return askForChannelToSelect
    when "quit"
      return :exit
    else
      puts "Unknown command \"#{input}\""
      return :askInput
    end
  end

  return command
end

def askForUserToSelect
  return askForRecipientToSelect("user", :select_user)
end

def askForChannelToSelect
  return askForRecipientToSelect("channel", :select_channel)
end

def askForRecipientToSelect(recipStr, funcSymbol)
  puts "Enter the #{recipStr}'s name or ID:"
  input = gets.chomp
  puts ""

  begin
    $workspace.method(funcSymbol).call input
  rescue ArgumentError => e
    puts "⚠️  #{e.to_s}"
    puts ""
    return :showCommands
  end
  return :showSelectedRecipient
end


def execute(command)
  return command
end


def prnt(command)
  case command
  when :showCommands
    printCommands
    return :askInput
  when :listUsers
    allUsers = $workspace.users
    tp allUsers, :name, :real_name, :status_text, :status_emoji, :slack_id
    puts ""
    return :showCommands
  when :listChannels
    allChannels = $workspace.channels
    tp allChannels, :name, :topic, :member_count, :slack_id
    puts ""
    return :showCommands
  when :showSelectedRecipient
    return :showCommands
  end

  return command
end

def printCommands
  puts "Available commands:"
  puts "  list users"
  puts "  list channels"
  puts "  select user"
  puts "  select channel"
  puts "  help"
  puts "  quit"
end

main if __FILE__ == $PROGRAM_NAME