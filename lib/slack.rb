#!/usr/bin/env ruby

def main
  puts "Welcome to the Ada Slack CLI!"

  command = :showCommands
  until command == :exit
    command = print(execute(read(command)))
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
  # TODO project
    when "quit"
      return :exit
    else
      puts "Unknown command \"#{input}\""
      return :askInput
    end
  end

  return command
end

def execute(command)
  return command
end

def print(command)
  case command
  when :showCommands
    puts "Available commands:"
    puts "  list users"
    puts "  list channels"
    puts "  help"
    puts "  quit"
    return :askInput
  when :listUsers

    return :askInput
  when :listChannels

    return :askInput
  end

  return command
end

main if __FILE__ == $PROGRAM_NAME