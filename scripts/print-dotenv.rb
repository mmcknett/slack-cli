require 'dotenv'
Dotenv.load

puts "The Slack Secret is #{ENV['SLACK_SECRET']}"
